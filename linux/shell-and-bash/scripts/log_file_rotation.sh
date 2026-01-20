FILE: linux/shell-and-bash/scripts/logs/log_file_rotation.sh
===============================================================================

#!/usr/bin/env bash
set -euo pipefail

# log_file_rotation.sh
# Usage:
#   ./log_file_rotation.sh /path/to/logfile.log [max_bytes] [keep_count]
#
# Default:
# - max_bytes: 10485760 (10MB)
# - keep_count: 5
#
# Rotation:
# - logfile -> logfile.YYYYmmdd-HHMMSS
# - creates a new empty logfile with same owner/group/mode as original

LOG_FILE="${1:-}"
MAX_SIZE="${2:-10485760}"
KEEP_COUNT="${3:-5}"

die() { echo "ERROR: $*" >&2; exit 1; }

[[ -n "${LOG_FILE}" ]] || die "log file path required"
[[ -f "${LOG_FILE}" ]] || die "log file '${LOG_FILE}' does not exist"

# Validate numeric inputs
[[ "${MAX_SIZE}" =~ ^[0-9]+$ ]] || die "max_bytes must be an integer"
[[ "${KEEP_COUNT}" =~ ^[0-9]+$ ]] || die "keep_count must be an integer"

rotate_if_needed() {
  local size
  size="$(stat -c '%s' "${LOG_FILE}")"

  if (( size < MAX_SIZE )); then
    echo "OK: '${LOG_FILE}' size=${size} bytes (below threshold ${MAX_SIZE})"
    return 0
  fi

  local ts
  ts="$(date +%Y%m%d-%H%M%S)"

  local owner group mode
  owner="$(stat -c '%U' "${LOG_FILE}")"
  group="$(stat -c '%G' "${LOG_FILE}")"
  mode="$(stat -c '%a' "${LOG_FILE}")"

  mv -- "${LOG_FILE}" "${LOG_FILE}.${ts}"
  : > "${LOG_FILE}"
  chown -- "${owner}:${group}" "${LOG_FILE}"
  chmod -- "${mode}" "${LOG_FILE}"

  echo "OK: rotated to '${LOG_FILE}.${ts}' and recreated '${LOG_FILE}'"
}

cleanup_old() {
  # Keep newest KEEP_COUNT rotations
  local pattern="${LOG_FILE}."[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]
  local files
  files="$(ls -1t ${pattern} 2>/dev/null || true)"

  if [[ -z "${files}" ]]; then
    echo "OK: no rotated files to clean"
    return 0
  fi

  local total
  total="$(echo "${files}" | wc -l | awk '{print $1}')"

  if (( total <= KEEP_COUNT )); then
    echo "OK: ${total} rotated files (<= keep_count ${KEEP_COUNT})"
    return 0
  fi

  # Delete from KEEP_COUNT+1 onward
  echo "${files}" | tail -n +"$((KEEP_COUNT + 1))" | while read -r f; do
    rm -f -- "${f}"
    echo "Deleted: ${f}"
  done
}

rotate_if_needed
cleanup_old

