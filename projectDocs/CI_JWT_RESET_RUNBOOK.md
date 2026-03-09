# CI JWT Reset Runbook (Connected App)

## Purpose

Reset Salesforce CI auth to a deterministic baseline using Connected App JWT and repository-level secrets only.

## Preconditions

- You have repo admin access for `JoshUX-SFPortfolio/sf-catalyst-portfolio`.
- You have Salesforce admin access in the target org.
- Stage 1 baseline check has passed locally.

## 1) Remove stale CI auth secrets

Delete Salesforce CI auth secrets from both scopes:

- Repository level: delete `SF_CLIENT_ID`, `SF_USERNAME`, `SF_INSTANCE_URL`, `SF_SERVER_KEY`.
- Organization level: delete Salesforce CI auth secrets used by this repo (`SF_CLIENT_ID`, `SF_USERNAME`, `SF_INSTANCE_URL`, `SF_SERVER_KEY`, `SF_JWT_KEY`) to prevent shadowing/confusion.

## 2) Recreate Connected App for CI

In Salesforce App Manager:

1. Create a new **Connected App** (CI-only app).
2. Enable OAuth settings and **Enable JWT Bearer Flow**.
3. Upload `server.crt` that matches your private key.
4. Save and wait for propagation.
5. Copy **Consumer Key**.

## 3) Set canonical repository secrets

Set exactly these repository secrets:

- `SF_CLIENT_ID` = Connected App Consumer Key
- `SF_USERNAME` = CI integration username in the same org
- `SF_INSTANCE_URL` = login host for that same org
- `SF_SERVER_KEY` = raw PEM private key text (`-----BEGIN ... PRIVATE KEY-----`)

## 4) Local JWT smoke test (before GitHub rerun)

```bash
sf org login jwt \
  --client-id "$SF_CLIENT_ID" \
  --jwt-key-file /path/to/server.key \
  --username "$SF_USERNAME" \
  --instance-url "$SF_INSTANCE_URL" \
  --alias ci-smoke
```

Expected: login succeeds.

## 5) CI validation sequence

1. Re-run `Develop Integration` on `develop`.
2. Confirm JWT auth step passes and scratch org creation starts.
3. Open/update a test PR to `develop` and confirm `validate` check status is produced.
4. Perform negative test by temporarily clearing one secret and verify preflight fails with explicit message.

## 6) Acceptance evidence to capture

- Screenshot/log of successful local JWT smoke test.
- GitHub Actions run link with successful JWT auth step.
- PR check screenshot showing `validate` status.
- Short note in `projectDocs/CICD_ADDENDUM.md` with date and final status.
