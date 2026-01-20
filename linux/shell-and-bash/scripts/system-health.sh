===============================================================================
FILE: linux/shell-and-bash/scripts/ops/system-health.sh
===============================================================================

#!/usr/bin/env bash
set -euo pipefail

# system-health.sh
# Usage:
#   ./system-health.sh [log_file]
#
# Purpose:
# - Collect a quick, read-only system snapshot for LFCS troubleshooting drills.
# - Writes output to a user-writable log file by default.

DEFAULT_LOG_DIR="${HOME}/lfcs-labs/system-health"
DEFAULT_LOG_FILE="${DEFAULT_LOG_DIR}/system_health.log"
LOG_FILE="${1:-$DEFAULT_LOG_FILE}"

mkdir -p "$DEFAULT_LOG_DIR"

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log() {
  echo "$(timestamp) - $*" | tee -a "$LOG_FILE"
}

section() {
  echo "" | tee -a "$LOG_FILE"
  echo "===== $* =====" | tee -a "$LOG_FILE"
}

have() { command -v "$1" >/dev/null 2>&1; }

log "Starting System Health Check"
log "Log file: $LOG_FILE"

section "Uptime"
uptime | tee -a "$LOG_FILE" || true

section "CPU Usage"
if have mpstat; then
  mpstat | tee -a "$LOG_FILE" || true
else
  log "mpstat not found (package: sysstat). Skipping."
fi

section "Memory Usage"
free -h | tee -a "$LOG_FILE" || true

section "Disk Usage"
df -h | tee -a "$LOG_FILE" || true

section "Top 5 Processes by CPU"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6 | tee -a "$LOG_FILE" || true

log "Completed System Health Check"

---
