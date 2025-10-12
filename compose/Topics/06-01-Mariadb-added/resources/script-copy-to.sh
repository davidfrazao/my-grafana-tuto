#!/usr/bin/env bash
# Copy the contents of specific directories into a destination,
# excluding listed file extensions, and show which files were updated.
set -Eeuo pipefail

echo "=== Copy directory contents (with exclusions) ==="
echo "PWD: $PWD"
echo "Running as user: $USER"
echo "Real username: $(whoami)"
echo "UID: $(id -u)"
echo "Groups: $(id -Gn)"
echo

# --- List of directories to copy (contents only) ---
SOURCE_DIRS=(
  "compose/Topics/03-02-Terraform-add-elasticsearch-datasources/resources"
)

# --- Destination root ---
DESTINATION="compose/data"

# --- Excluded file extensions (patterns) ---
EXCLUDED_EXTENSIONS=(
  "*.sh"
  # "*.tmp"
  # "*.bak"
  # Add more if needed
)

# Build exclusion parameters for rsync dynamically
RSYNC_EXCLUDES=()
for pattern in "${EXCLUDED_EXTENSIONS[@]}"; do
  RSYNC_EXCLUDES+=(--exclude="$pattern")
done

# Ensure destination exists
mkdir -p "$DESTINATION"

# Temp log file for rsync itemized output
CHANGES_LOG="$(mktemp)"
trap 'rm -f "$CHANGES_LOG"' EXIT

echo "Copying contents of:"
printf '  - %s\n' "${SOURCE_DIRS[@]}"
echo "into destination: $DESTINATION"
echo "Excluding patterns:"
printf '  - %s\n' "${EXCLUDED_EXTENSIONS[@]}"
echo

# --- Copy loop ---
for SRC in "${SOURCE_DIRS[@]}"; do
  if [[ -d "$SRC" ]]; then
    echo ">>> Copying contents of $SRC -> $DESTINATION"
    # Copy contents only (trailing / on SRC)
    rsync -a \
      "${RSYNC_EXCLUDES[@]}" \
      --itemize-changes \
      --out-format='%i %n' \
      "$SRC"/ "$DESTINATION"/ | tee -a "$CHANGES_LOG" >/dev/null
  else
    echo "Skipping (not found): $SRC"
  fi
done

echo
echo "✅ Copy completed."
echo

# --- Summary of updated or new files ---
echo "=== Summary of files copied/updated (excluding patterns) ==="

UPDATED_FILES=$(grep -E '^>f' "$CHANGES_LOG" || true)
CREATED_DIRS=$(grep -E '^cd\+{9} ' "$CHANGES_LOG" || true)
META_ONLY=$(grep -E '^\.f|^c[f.]' "$CHANGES_LOG" || true)

if [[ -n "$UPDATED_FILES" ]]; then
  echo "Files updated or created:"
  echo "$UPDATED_FILES" | sed -E 's/^>f[[:graph:]]*[[:space:]]+//'
else
  echo "Files updated or created: (none)"
fi

if [[ -n "$CREATED_DIRS" ]]; then
  echo
  echo "Directories created:"
  echo "$CREATED_DIRS" | sed -E 's/^cd\+{9}[[:space:]]+//'
fi

if [[ -n "$META_ONLY" ]]; then
  echo
  echo "Files with metadata-only changes (perms/mtime/owner):"
  echo "$META_ONLY" | sed -E 's/^[^.c][[:graph:]]*[[:space:]]+//; s/^[^.c]+[[:space:]]+//'
fi

echo
echo "Done."
