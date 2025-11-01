#!/bin/bash

set -euo pipefail
shopt -s nullglob  # avoid literal *.sh if folder is empty

echo "Start: $(date)"
echo "Starting scripts from /app/scripts.d"
echo

SCRIPTS_DIR="/app/scripts.d"
TARGET_DIR="/media"

# Iterate over each script in scripts.d
for script in "$SCRIPTS_DIR"/*.sh; do
    script_name=$(basename "$script")
    echo "➡️ Processing $script_name"

    # Copy to /media
    cp "$script" "$TARGET_DIR/$script_name"

    # Move into /media and execute
    (
        cd "$TARGET_DIR"
        chmod +x "$script_name"
        echo "Running $script_name..."
        ./ "$script_name"
    )

    # Remove after execution
    rm -f "$TARGET_DIR/$script_name"
    echo "✅ Finished $script_name"
    echo
done

echo "All scripts complete."
echo "Triggering Jellyfin library refresh via API..."

if [ -z "$JF_URL" ] || [ -z "$JF_API_KEY" ]; then
    echo "JF_URL and JF_API_KEY must be set to call Jellyfin api"
    exit 1
else
    jfurl="$JF_URL/library/refresh?api_key=$JF_API_KEY"
    echo "Calling jellyfin endpoint: $jfurl"

    curl -s -S -d "" -w "Jellyfin library refresh completed with http_code:%{http_code}\\n" -H "Accept: application/json" "$jfurl"
fi

echo "End: $(date)"