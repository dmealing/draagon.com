#!/bin/bash
# Deploy draagon.com to Cloudflare Pages
# Usage: ./deploy.sh
#
# Auth is a scoped API token only (pages-deploy-draagon-com, Account > Pages
# Write). CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID are always fetched from
# the key store (Infisical, project deploy, env dev) through keys-axi, which
# holds the token as CLOUDFLARE_PAGES_TOKEN_DRAAGON_COM. Values already exported
# in the caller's environment are ignored. No env files, no fallback to the
# global API key. Values are never printed.
#
# wrangler is pinned to WRANGLER_VERSION and run through npx, so no
# node_modules lands in the deployed directory. Set WRANGLER_BIN to override the
# binary, e.g. to a stand-in when testing this script.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WRANGLER_VERSION="4.158.0"

# Never let a global key from the caller's environment reach wrangler.
unset CLOUDFLARE_API_KEY CLOUDFLARE_EMAIL CF_KEY CF_EMAIL CF_ACCOUNT

if [ -z "${DEPLOY_KEYS_FETCHED:-}" ]; then
  if ! command -v keys-axi >/dev/null 2>&1; then
    echo "deploy.sh: keys-axi not found; it is required to fetch the Cloudflare credentials" >&2
    exit 1
  fi
  # Drop anything the caller exported, so only key-store values can reach wrangler.
  unset CLOUDFLARE_API_TOKEN CLOUDFLARE_ACCOUNT_ID CLOUDFLARE_PAGES_TOKEN_DRAAGON_COM
  # Re-run this script with the keys in its environment, mapping the stored
  # token name to the one wrangler reads. If the store is unreachable, keys-axi
  # fails here and wrangler never runs.
  export DEPLOY_KEYS_FETCHED=1
  # shellcheck disable=SC2016 # single quotes are intentional: expand in the child
  exec keys-axi run --project deploy --env dev \
    --only CLOUDFLARE_PAGES_TOKEN_DRAAGON_COM CLOUDFLARE_ACCOUNT_ID -- \
    bash -c 'export CLOUDFLARE_API_TOKEN="${CLOUDFLARE_PAGES_TOKEN_DRAAGON_COM:-}"; unset CLOUDFLARE_PAGES_TOKEN_DRAAGON_COM; exec "$0" "$@"' "$0" "$@"
fi

if [ -z "${CLOUDFLARE_API_TOKEN:-}" ] || [ -z "${CLOUDFLARE_ACCOUNT_ID:-}" ]; then
  echo "deploy.sh: the key store did not supply CLOUDFLARE_PAGES_TOKEN_DRAAGON_COM and CLOUDFLARE_ACCOUNT_ID (project deploy, env dev)" >&2
  exit 1
fi

export CLOUDFLARE_API_TOKEN CLOUDFLARE_ACCOUNT_ID

if [ -n "${WRANGLER_BIN:-}" ]; then
  WRANGLER=("$WRANGLER_BIN")
else
  WRANGLER=(npx --yes "wrangler@$WRANGLER_VERSION")
fi

"${WRANGLER[@]}" pages deploy "$SCRIPT_DIR" \
  --project-name=draagon-com \
  --branch=main \
  --commit-message="Deploy $(date +%Y-%m-%d\ %H:%M:%S)"

echo "Deployed to https://draagon.com"
