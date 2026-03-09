#!/usr/bin/env bash
set -euo pipefail

# Stage 1 baseline gate for CI recovery.
# Usage:
#   scripts/ci/stage1-baseline-check.sh [target-org-alias]
# Default org alias: catalyst-scratch

TARGET_ORG="${1:-catalyst-scratch}"

echo "[1/4] Branch + working tree state"
git status --short --branch

echo "[2/4] Verify local unit baseline (lwc-jest)"
npm run test:unit -- --ci

echo "[3/4] Verify Apex test baseline on target org: ${TARGET_ORG}"
sf apex run test \
  --target-org "${TARGET_ORG}" \
  --test-level RunLocalTests \
  --result-format human \
  --wait 20

echo "[4/4] Stage 1 baseline check complete"
