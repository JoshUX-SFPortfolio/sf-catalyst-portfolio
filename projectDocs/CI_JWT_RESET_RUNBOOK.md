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

## 2) Recreate Connected App for CI (Salesforce newer UI)

As of Spring '26, Salesforce routes connected app creation through the newer setup pages.

Path:

1. Setup -> **Apps** -> **Connected Apps** -> **Settings**.
2. Click **New Connected App**.

Configure these settings exactly:

| Area | Setting | Value |
|---|---|---|
| Basic | App Type | Connected App |
| OAuth | Enable OAuth Settings | Enabled |
| OAuth | Callback URL | `http://localhost:1717/OauthRedirect` |
| OAuth | Use Digital Signatures | Enabled, upload `server.crt` (must match `server.key`) |
| OAuth Scopes | Selected OAuth Scopes | `Manage user data via APIs (api)`, `Perform requests at any time (refresh_token, offline_access)`, `Manage user data via Web browsers (web)` |
| OAuth Advanced | Require PKCE | Disabled |
| OAuth Advanced | Require Secret for Web Server Flow | Disabled |
| OAuth Advanced | Require Secret for Refresh Token Flow | Disabled |
| OAuth Advanced | Enable Client Credentials Flow | Disabled |
| OAuth Advanced | Enable Authorization Code and Credentials Flow | Disabled |
| OAuth Advanced | Enable Token Exchange Flow | Disabled |
| OAuth Advanced | Enable Refresh Token Rotation | Disabled |
| OAuth Advanced | **Issue JSON Web Token (JWT)-based access tokens for named users** | **Disabled (critical for CLI/Metadata API compatibility)** |
| OAuth Advanced | Introspect All Tokens / Configure ID Token / Enable Asset Tokens / Enable Single Logout | Disabled |

Then open **Manage Connected Apps** -> your app -> **Edit Policies** and set:

| Policy | Value |
|---|---|
| Permitted Users | `Admin approved users are pre-authorized` |
| Profiles/Permission Sets | Include the integration user (profile or permission set) |
| IP Relaxation | `Relax IP restrictions` |
| Refresh Token Policy | `Refresh token is valid until revoked` |
| Session Policy | `Use the user's default session timeout` |
| High Assurance Session Required | Disabled |

Save and wait 5-10 minutes for propagation before testing.

## 3) Set canonical repository secrets

Set exactly these repository secrets:

- `SF_CLIENT_ID` = Connected App Consumer Key
- `SF_USERNAME` = CI integration username in the same org
- `SF_INSTANCE_URL` = login host for that same org
- `SF_SERVER_KEY` = raw PEM private key text (`-----BEGIN ... PRIVATE KEY-----`)

## 3b) Set CI mode variable (scratch quota gate)

Configure repository variable:

- `CI_SCRATCH_MODE=stabilize` (default)

Modes:

- `stabilize`: run secret preflight + JWT login + SOAP probe only (no scratch creation).
- `full`: allow scratch org creation path. If daily quota is exhausted, workflow falls back to non-scratch path and exits success with warning summary.

Re-enable policy:

- Only switch to `CI_SCRATCH_MODE=full` after manual confirmation that stabilization runs are reliable and ready for full deploy/test gates.

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

Important:

- `SF_INSTANCE_URL` must be the org login host (for example, `https://orgfarm-2c5a84acfb-dev-ed.develop.my.salesforce.com`).
- Do not use Lightning or setup hosts such as `.lightning.force.com` or `.my.salesforce-setup.com`.

## 5) CI validation sequence

1. Set `CI_SCRATCH_MODE=stabilize`.
2. Re-run `Develop Integration` on `develop`.
3. Confirm preflight + JWT auth + SOAP probe pass, and scratch stages are skipped by design.
4. Open/update a test PR to `develop` and confirm `validate` check status is produced and green.
5. Switch to `CI_SCRATCH_MODE=full` only when ready for full scratch-path validation.
6. In `full` mode, verify behavior:
   - Quota available: scratch create/deploy/test/delete runs.
   - Quota exhausted: workflow falls back with explicit summary artifact and does not hard-fail.
7. Perform negative test by temporarily clearing one secret and verify preflight fails with explicit message.

## 6) Acceptance evidence to capture

- Screenshot/log of successful local JWT smoke test.
- GitHub Actions run link with successful JWT auth + SOAP probe steps.
- PR check screenshot showing `validate` status.
- Artifact showing mode/quota decision (`ci-mode-summary-*`).
- Short note in `projectDocs/CICD_ADDENDUM.md` with date and final status.

## 7) C-1016 troubleshooting checklist

If `sf org create scratch` fails with `RemoteOrgSignupFailed` and `C-1016`, check in this order:

1. Connected app has all three scopes: `api`, `refresh_token/offline_access`, and `web`.
2. `Issue JSON Web Token (JWT)-based access tokens for named users` is **off**.
3. Callback URL is exactly `http://localhost:1717/OauthRedirect`.
4. Cert/key pair matches (`server.crt` uploaded, same pair as `SF_SERVER_KEY`/`server.key`).
5. Permitted users + profile/permission set include the CI user.
6. IP Relaxation is `Relax IP restrictions`.
7. Wait 5-10 minutes after policy changes, then re-authenticate and retry.

Useful local reset sequence:

```bash
sf org logout --target-org ci-org-local --no-prompt
sf org login jwt --client-id "$SF_CLIENT_ID" --jwt-key-file /path/to/server.key --username "$SF_USERNAME" --instance-url "$SF_INSTANCE_URL" --alias ci-org-local
sf org create scratch --definition-file config/project-scratch-def.json --alias ci-org-local-scratch --duration-days 1 --wait 15 --target-dev-hub ci-org-local
```
