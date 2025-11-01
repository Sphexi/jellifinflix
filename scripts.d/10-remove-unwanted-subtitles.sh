#!/bin/bash
# remove_non_english_subs.sh
# Usage:
#   ./remove_non_english_subs.sh

set -euo pipefail
shopt -s nocasematch  # case-insensitive regex match

DELETE=0  # Set to 1 to actually delete files, 0 for dry-run
TARGET_DIR="."

# Find subtitle files (case-insensitive), handle spaces/newlines safely.
find "$TARGET_DIR" -type f \( \
  -iname '*.srt' -o -iname '*.scc' -o -iname '*.vtt' -o -iname '*.sub' -o -iname '*.ass' \
\) -print0 |
while IFS= read -r -d '' file; do
  base="$(basename "$file")"

  # Keep only files that contain ".en." or ".eng." immediately before the extension
  # Examples matched: movie.en.srt, show.eng.vtt, doc.hi.en.sub
  if [[ "$base" =~ \.en(g)?\.(srt|scc|vtt|sub|ass)$ ]]; then
    echo "✅ Keeping: $file"
  else
    if [[ $DELETE -eq 1 ]]; then
      echo "🗑️ Removing: $file"
      rm -f -- "$file"
    else
      echo "DRY-RUN would remove: $file"
    fi
  fi
done
