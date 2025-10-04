#!/usr/bin/env bash
# Backup multiple directories into BACKUP_ROOT/<timestamp>/<source_dir>
# then (optionally) compress timestamp folders older than RETENTION_DAYS
set -Eeuo pipefail

echo "=== Backup + Cleanup Persistent Data from Local Disk ==="
echo "PWD: $PWD"
echo "Running as user: $USER"
echo "Real username: $(whoami)"
echo "UID: $(id -u)"
echo "Groups: $(id -Gn)"

# --- Directories to back up and then (optionally) clean up ---
CLEANUP_DIRS=(
  "compose/data/elasticsearch/data"
  "compose/data/elasticsearch_exporter/"
  "compose/data/fake-logs/"
  "compose/data/grafana/data/"
  "compose/data/grafana/etc/"
  "compose/data/mariadb/"
  "compose/data/mysqld-exporter/"
  "compose/data/prometheus/data/"
  "compose/data/prometheus/etc/"
  "compose/data/terraform/"
  # add more if you like, e.g. "/var/lib/something"
)

BACKUP_ROOT="./backups"   # Where backups are stored
RETENTION_DAYS=7          # Days after which *timestamp folders* get zipped

# Create backup root if missing
mkdir -p "$BACKUP_ROOT"

# Timestamp used in backup folder names (date + hour/minute)
timestamp="$(date '+%Y%m%d-%H%M')"

# Create the timestamp folder once
TIMESTAMP_DIR="$BACKUP_ROOT/$timestamp"
mkdir -p "$TIMESTAMP_DIR"

# --- First: copy each source dir into the timestamp folder, preserving path ---
for SRC in "${CLEANUP_DIRS[@]}"; do
  if [[ ! -d "$SRC" ]]; then
    echo "Skipping (not found): $SRC"
    continue
  fi

  # Strip any leading '/' so we don't create an absolute path under the backup root
  rel_src="${SRC#/}"
  dest_dir="$TIMESTAMP_DIR/$rel_src"

  echo ">>> Backing up '$SRC' to '$dest_dir'..."
  mkdir -p "$dest_dir"
  rsync -a "$SRC"/ "$dest_dir"/
  echo ">>> Backup complete: $dest_dir"
done

# --- Second: compress *timestamp* folders older than RETENTION_DAYS ---
echo ">>> Compressing timestamp folders older than ${RETENTION_DAYS} days..."
find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d -mtime +"$RETENTION_DAYS" -print0 \
| while IFS= read -r -d '' dir; do
  zipfile="${dir}.zip"
  if [[ -e "$zipfile" ]]; then
    echo "    Skipping (already zipped): $(basename "$dir")"
    continue
  fi

  echo "    Zipping: $(basename "$dir") -> $(basename "$zipfile")"
  (
    cd "$(dirname "$dir")"
    zip -r -q -9 "$(basename "$zipfile")" "$(basename "$dir")"
  )

  if unzip -tqq "$zipfile" >/dev/null 2>&1; then
    rm -rf "$dir"
    echo "    Compressed and removed original: $zipfile"
  else
    echo "    ERROR: Zip verification failed for $zipfile. Keeping original directory." >&2
    rm -f "$zipfile"
  fi
done

echo ">>> Backup + compression phase done."

# --- Third: Cleanup phase (DRY RUN by default) ---
echo "=== Cleanup Phase ==="
for dir in "${CLEANUP_DIRS[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "Removing: $dir"
    # ⚠️ Remove the leading '#' to actually delete:
    # rm -rf "$dir"/* #removes normal files and folders
    rm -rf "${dir:?}/"* "${dir:?}/".[!.]* "${dir:?}/"..?* 2>/dev/null || true
    # printf "DRY RUN: rm -rf %q\n" "$dir"
  else
    echo "Skipping, not found: $dir"
  fi
done

echo "All operations completed."
