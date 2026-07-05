#!/usr/bin/env bash
set -euo pipefail

# Deploy sarasirout.com portfolio to GitHub Pages
# Run from this directory after: gh auth login

REPO="sarasirout-portfolio"
OWNER="sarasi-rout"

echo "→ Checking GitHub auth..."
gh auth status

echo "→ Creating repo (if needed) and pushing..."
if ! gh repo view "$OWNER/$REPO" &>/dev/null; then
  gh repo create "$REPO" --public --source=. --remote=origin --push
else
  git push -u origin main
fi

echo "→ Enabling GitHub Pages..."
gh api "repos/$OWNER/$REPO/pages" -X POST \
  -f build_type=legacy \
  -f source[branch]=main \
  -f source[path]=/

echo "→ Setting custom domain..."
gh api "repos/$OWNER/$REPO/pages" -X PUT -f cname=sarasirout.com

echo ""
echo "✓ Site pushed! Next: configure Cloudflare DNS (see below)."
echo "  GitHub Pages URL: https://$OWNER.github.io/$REPO/"
echo "  Custom domain (after DNS): https://sarasirout.com"
