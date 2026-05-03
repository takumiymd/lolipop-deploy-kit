#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"

echo "Checking static site in: $TARGET_DIR"

if [ ! -f "$TARGET_DIR/index.html" ]; then
  echo "FAIL: index.html not found"
  exit 1
fi

if [ ! -d "$TARGET_DIR/assets" ]; then
  echo "WARN: assets/ directory not found"
fi

if [ -d "$TARGET_DIR/.github/workflows" ]; then
  echo "OK: GitHub workflows directory exists"
else
  echo "WARN: .github/workflows directory not found"
fi

find "$TARGET_DIR" -name ".DS_Store" -print | while read -r file; do
  echo "WARN: remove macOS metadata file: $file"
done

echo "Done."
