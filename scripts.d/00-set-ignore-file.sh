#!/bin/bash
# set-ignore-file.sh
# Usage:
#   ./set-ignore-file.sh

set -euo pipefail
shopt -s nocasematch  # case-insensitive regex match - not currently necessary but standardizing across all scripts

# Extensions to consider "video files"
is_video_expr=( -iname '*.mkv' -o -iname '*.mp4' -o -iname '*.avi' -o -iname '*.mpg' -o -iname '*.mpeg' )

# Walk every directory under the current tree
while IFS= read -r -d '' dir; do
  full_path="$dir/.ignore"

  # Does this directory (recursively) contain ANY video file?
  if find "$dir" -type f \( "${is_video_expr[@]}" \) -print -quit >/dev/null 2>&1; then
    # Video(s) present — ensure .ignore is removed
    if [[ -f "$full_path" ]]; then
      rm -f -- "$full_path"
      echo "$dir - Video file exists. removed $full_path"
    else
      echo "$dir - Video file exists. skipping folder"
    fi
  else
    # No videos anywhere under this dir — ensure .ignore exists
    if [[ -f "$full_path" ]]; then
      echo "$dir is up to date."
    else
      touch -- "$full_path"
      echo "$dir - No video file exists. created $full_path"
    fi
  fi
done < <(find . -type d -print0)