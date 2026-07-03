#!/usr/bin/env bash
# Syncs the public subset of ../wiki into ./content for Quartz to build.
# Only these topic folders are published; work/, journal/, sources/, and
# meta files (CLAUDE.md, SCHEMA.md, index.md, log.md) stay private.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE_DIR="$(dirname "$SCRIPT_DIR")"
WIKI_DIR="$SITE_DIR/../wiki"
CONTENT_DIR="$SITE_DIR/content"

PUBLIC_FOLDERS=(ai-ml ai-engineering ai-industry ai-safety mathematics physics textbooks)

for folder in "${PUBLIC_FOLDERS[@]}"; do
  if [ -d "$WIKI_DIR/$folder" ]; then
    rm -rf "${CONTENT_DIR:?}/$folder"
    mkdir -p "$CONTENT_DIR/$folder"
    cp -r "$WIKI_DIR/$folder/." "$CONTENT_DIR/$folder/"
    echo "synced $folder"
  else
    echo "skip $folder (not found in wiki/)"
  fi
done

echo "done. content/index.md is hand-written and untouched by this script."
