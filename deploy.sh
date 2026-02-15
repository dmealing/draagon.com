#!/bin/bash
# Deploy draagon.com to Cloudflare Pages
# Usage: ./deploy.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source ~/.config/cloudflare/credentials

CLOUDFLARE_EMAIL="$CF_EMAIL" \
CLOUDFLARE_API_KEY="$CF_KEY" \
CLOUDFLARE_ACCOUNT_ID="$CF_ACCOUNT" \
wrangler pages deploy "$SCRIPT_DIR" \
  --project-name=draagon-com \
  --branch=main \
  --commit-message="Deploy $(date +%Y-%m-%d\ %H:%M:%S)"

echo "Deployed to https://draagon.com"
