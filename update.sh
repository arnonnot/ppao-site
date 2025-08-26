\
#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./update.sh <source.html> <category> <slug>
# Example:
#   ./update.sh "/path/to/file.html" hr khrxngkar-thdsxb
#
# Requirements:
# - You have run: gh auth login
# - You have write access to the repo's remote (origin)

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <source.html> <category> <slug>"
  exit 1
fi

SRC="$1"
CATEGORY="$2"
SLUG="$3"

if [[ ! -f "$SRC" ]]; then
  echo "Source file not found: $SRC"
  exit 1
fi

# Ensure we are at repo root (contains .git or known files)
if [[ ! -d ".git" ]]; then
  echo "Please run this script at the repo root (where .git is)."
  exit 1
fi

DEST_DIR="pages/${CATEGORY}/${SLUG}"
DEST_FILE="${DEST_DIR}/index.html"

mkdir -p "$DEST_DIR"

# Clean the HTML: remove header/nav and enforce desktop viewport
python3 - "$SRC" "$DEST_FILE" << 'PY'
import sys, re, io

src, dest = sys.argv[1], sys.argv[2]
with io.open(src, "r", encoding="utf-8", errors="ignore") as f:
    html = f.read()

patterns = [
    r'<header[^>]*>.*?</header>',
    r'<div[^>]+class="[^"]*sites-header[^"]*"[^>]*>.*?</div>',
    r'<nav[^>]*>.*?</nav>'
]
for pat in patterns:
    html = re.sub(pat, '', html, flags=re.DOTALL|re.IGNORECASE)

viewport_tag_pattern = re.compile(r'<meta\s+name=["\']viewport["\'][^>]*>', re.IGNORECASE)
desktop_viewport = '<meta name="viewport" content="width=1200">'
if viewport_tag_pattern.search(html):
    html = viewport_tag_pattern.sub(desktop_viewport, html, count=1)
else:
    html = re.sub(r'(<head[^>]*>)', r'\\1\\n  ' + desktop_viewport, html, 1, flags=re.IGNORECASE)

with io.open(dest, "w", encoding="utf-8") as f:
    f.write(html)
print(f"Wrote cleaned page to: {dest}")
PY

# Git add/commit/push
git add "$DEST_FILE"
git commit -m "feat(page): add/update ${CATEGORY}/${SLUG}"
git push

echo "Done. Page URL (GitHub Pages):"
# Try to infer GitHub username from git remote origin
ORIGIN_URL="$(git remote get-url origin || true)"
# Expected formats:
#  https://github.com/<user>/<repo>.git
#  git@github.com:<user>/<repo>.git
USER_REPO=""
if [[ "$ORIGIN_URL" =~ github.com[:/]+([^/]+)/([^/.]+) ]]; then
  USER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
  echo "  https://${USER}.github.io/pages/${CATEGORY}/${SLUG}/"
else
  echo "  https://<username>.github.io/pages/${CATEGORY}/${SLUG}/"
fi
