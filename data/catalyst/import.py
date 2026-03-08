#!/usr/bin/env python3
"""
Catalyst vertical sample data import script.
Imports Accounts → Contacts → Opportunities → Leads → Cases in dependency order.
Uses Bulk API 2.0 for speed. Cross-object references resolved via Name lookup.

Usage: python3 data/catalyst/import.py [--org <alias>]
"""
import subprocess, json, csv, io, sys, os, argparse, tempfile

DEFAULT_ORG = 'catalyst-scratch'
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

parser = argparse.ArgumentParser()
parser.add_argument('--org', default=DEFAULT_ORG)
args = parser.parse_args()
ORG = args.org

def sf_query(soql):
    result = subprocess.run(
        ['sf', 'data', 'query', '--query', soql,
         '--target-org', ORG, '--json'],
        capture_output=True, text=True
    )
    data = json.loads(result.stdout)
    if data.get('status') != 0:
        print(f'  QUERY ERROR: {data.get("message","")}')
        return []
    return data.get('result', {}).get('records', [])

def bulk_import(sobject, csv_content):
    """Write CSV to temp file and bulk import. Returns job result."""
    with tempfile.NamedTemporaryFile(mode='w', suffix='.csv', delete=False, newline='') as f:
        f.write(csv_content)
        tmp = f.name
    try:
        result = subprocess.run(
            ['sf', 'data', 'import', 'bulk',
             '--sobject', sobject,
             '--file', tmp,
             '--target-org', ORG,
             '--line-ending', 'LF',
             '--wait', '10',
             '--json'],
            capture_output=True, text=True
        )
        data = json.loads(result.stdout)
        if data.get('status') != 0:
            print(f'  BULK ERROR: {data.get("message","")}')
            return None
        return data.get('result', {})
    finally:
        os.unlink(tmp)

def read_csv(path):
    with open(path, newline='') as f:
        reader = csv.DictReader(f)
        return list(reader), reader.fieldnames

def write_csv(rows, fieldnames):
    out = io.StringIO()
    writer = csv.DictWriter(out, fieldnames=fieldnames, lineterminator='\n', extrasaction='ignore')
    writer.writeheader()
    writer.writerows(rows)
    return out.getvalue()

print('=' * 60)
print('Catalyst Vertical — Sample Data Import')
print(f'Target org: {ORG}')
print('=' * 60)

# ── STEP 1: Import Accounts ──────────────────────────────────────
print('\n[1/5] Importing 50 Accounts...')
rows, _ = read_csv(f'{BASE_DIR}/accounts.csv')
# Drop placeholder Id column; omit BillingState/BillingCountry — fails when state/country picklists enabled
fields_acc = ['Name', 'Industry', 'Type', 'Phone', 'Website',
              'NumberOfEmployees', 'AnnualRevenue', 'Description',
              'Subscription_Tier__c', 'Modules_Purchased__c',
              'Annual_Contract_Value__c', 'Contract_Renewal_Date__c',
              'Health_Score__c', 'Platform_Usage_Index__c', 'CSAT_Average__c']
clean = [{f: r[f] for f in fields_acc} for r in rows]
acc_names = [r['Name'] for r in rows]
result = bulk_import('Account', write_csv(clean, fields_acc))
if result:
    print(f'  Accounts: {result.get("numberRecordsProcessed")} processed, '
          f'{result.get("numberRecordsFailed")} failed')

# Query back Account IDs by Name — build Name→ID map
print('  Querying Account IDs...')
acc_records = sf_query(
    "SELECT Id, Name FROM Account WHERE Name IN ("
    + ','.join(f"'{n.replace(chr(39),chr(92)+chr(39))}'" for n in acc_names)
    + ") LIMIT 200"
)
acc_id_map = {r['Name']: r['Id'] for r in acc_records}
# Also build ACC-xxx → SF ID map from original CSV
acc_ref_map = {}
for r in rows:
    sf_id = acc_id_map.get(r['Name'])
    if sf_id:
        acc_ref_map[r['Id']] = sf_id
print(f'  Mapped {len(acc_ref_map)}/50 Account IDs')

# ── STEP 2: Import Contacts ──────────────────────────────────────
print('\n[2/5] Importing 200 Contacts...')
rows, _ = read_csv(f'{BASE_DIR}/contacts.csv')
fields_con = ['FirstName', 'LastName', 'Title', 'Email', 'Phone',
              'Department', 'LeadSource', 'AccountId']
clean = []
con_emails = []
for r in rows:
    sf_acc = acc_ref_map.get(r['AccountId'], '')
    if not sf_acc:
        print(f'  WARN: No Account ID for {r["AccountId"]} (Contact {r["Id"]})')
        continue
    clean.append({
        'FirstName': r['FirstName'], 'LastName': r['LastName'],
        'Title': r['Title'], 'Email': r['Email'], 'Phone': r['Phone'],
        'Department': r['Department'], 'LeadSource': r['LeadSource'],
        'AccountId': sf_acc
    })
    con_emails.append(r['Email'])
result = bulk_import('Contact', write_csv(clean, fields_con))
if result:
    print(f'  Contacts: {result.get("numberRecordsProcessed")} processed, '
          f'{result.get("numberRecordsFailed")} failed')

# Query back Contact IDs by Email
print('  Querying Contact IDs...')
con_records = sf_query(
    "SELECT Id, Email FROM Contact WHERE Email IN ("
    + ','.join(f"'{e}'" for e in con_emails[:200])
    + ") LIMIT 200"
)
con_id_map = {r['Email']: r['Id'] for r in con_records}
# Build CON-xxx → SF ID map from original CSV
rows_orig, _ = read_csv(f'{BASE_DIR}/contacts.csv')
con_ref_map = {}
for r in rows_orig:
    sf_id = con_id_map.get(r['Email'])
    if sf_id:
        con_ref_map[r['Id']] = sf_id
print(f'  Mapped {len(con_ref_map)}/200 Contact IDs')

# ── Resolve RecordType IDs at runtime (Opportunity + Case) ──────
print('\n  Resolving RecordType IDs...')
rt_records = sf_query(
    "SELECT Id, DeveloperName, SobjectType FROM RecordType "
    "WHERE SobjectType IN ('Opportunity','Case') LIMIT 50"
)
rt_map = {(r['SobjectType'], r['DeveloperName']): r['Id'] for r in rt_records}
print(f'  Mapped {len(rt_map)} RecordType(s)')

# ── STEP 3: Import Opportunities ────────────────────────────────
print('\n[3/5] Importing 80 Opportunities...')
rows, _ = read_csv(f'{BASE_DIR}/opportunities.csv')
fields_opp = ['Name', 'StageName', 'CloseDate', 'Amount', 'Probability',
              'LeadSource', 'NextStep', 'Description', 'AccountId', 'RecordTypeId']
clean = []
for r in rows:
    sf_acc = acc_ref_map.get(r['AccountId'], '')
    if not sf_acc:
        print(f'  WARN: No Account for {r["AccountId"]} (Opp {r["Id"]})')
        continue
    rt_id = rt_map.get(('Opportunity', r['RecordTypeId']), '')
    if not rt_id:
        print(f'  WARN: No RecordType for Opportunity/{r["RecordTypeId"]} (Opp {r["Id"]})')
    clean.append({
        'Name': r['Name'], 'StageName': r['StageName'],
        'CloseDate': r['CloseDate'], 'Amount': r['Amount'],
        'Probability': r['Probability'], 'LeadSource': r['LeadSource'],
        'NextStep': r['NextStep'], 'Description': r['Description'],
        'AccountId': sf_acc, 'RecordTypeId': rt_id
    })
result = bulk_import('Opportunity', write_csv(clean, fields_opp))
if result:
    print(f'  Opportunities: {result.get("numberRecordsProcessed")} processed, '
          f'{result.get("numberRecordsFailed")} failed')

# ── STEP 4: Import Leads ─────────────────────────────────────────
print('\n[4/5] Importing 60 Leads...')
rows, _ = read_csv(f'{BASE_DIR}/leads.csv')
fields_lead = ['FirstName', 'LastName', 'Company', 'Title', 'Email',
               'Phone', 'LeadSource', 'Industry', 'Status', 'Rating', 'Description']
clean = [{f: r.get(f, '') for f in fields_lead} for r in rows]
result = bulk_import('Lead', write_csv(clean, fields_lead))
if result:
    print(f'  Leads: {result.get("numberRecordsProcessed")} processed, '
          f'{result.get("numberRecordsFailed")} failed')

# ── STEP 5: Import Cases ─────────────────────────────────────────
print('\n[5/5] Importing 120 Cases...')
rows, _ = read_csv(f'{BASE_DIR}/cases.csv')
fields_case = ['Subject', 'Status', 'Priority', 'Origin', 'Type',
               'Description', 'AccountId', 'ContactId', 'RecordTypeId']
clean = []
skipped = 0
for r in rows:
    sf_acc = acc_ref_map.get(r['AccountId'], '')
    sf_con = con_ref_map.get(r['ContactId'], '')
    if not sf_acc:
        skipped += 1
        continue
    rt_id = rt_map.get(('Case', r['RecordTypeId']), '')
    if not rt_id:
        print(f'  WARN: No RecordType for Case/{r["RecordTypeId"]} (Case {r.get("Id","")})')
    clean.append({
        'Subject': r['Subject'], 'Status': r['Status'],
        'Priority': r['Priority'], 'Origin': r['Origin'],
        'Type': r['Type'], 'Description': r['Description'],
        'AccountId': sf_acc,
        'ContactId': sf_con if sf_con else '',
        'RecordTypeId': rt_id
    })
if skipped:
    print(f'  Skipped {skipped} cases with unresolved Account refs')
result = bulk_import('Case', write_csv(clean, fields_case))
if result:
    print(f'  Cases: {result.get("numberRecordsProcessed")} processed, '
          f'{result.get("numberRecordsFailed")} failed')

print('\n' + '=' * 60)
print('Import complete.')
print('=' * 60)
