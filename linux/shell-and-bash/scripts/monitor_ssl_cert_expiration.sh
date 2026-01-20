iFILE: linux/shell-and-bash/scripts/ssl/monitor_ssl_cert_expiration.sh
===============================================================================

#!/usr/bin/env bash
set -euo pipefail

# monitor_ssl_cert_expiration.sh
# LFCS-safe template: uses openssl to check TLS expiry for domains.
#
# Usage:
#   ./monitor_ssl_cert_expiration.sh domains.txt [warn_days]
#
# domains.txt format:
#   example.com
#   api.example.com:443
#
# Output:
# - Prints expiry info
# - Exit code 0 always (operator tool), but you can hook it into cron.

DOMAINS_FILE="${1:-}"
WARN_DAYS="${2:-30}"

die() { echo "ERROR: $*" >&2; exit 1; }

[[ -n "${DOMAINS_FILE}" ]] || die "domains file required"
[[ -f "${DOMAINS_FILE}" ]] || die "domains file not found: ${DOMAINS_FILE}"
[[ "${WARN_DAYS}" =~ ^[0-9]+$ ]] || die "warn_days must be an integer"

check_one() {
  local hostport="$1"
  local host="${hostport%:*}"
  local port="${hostport#*:}"
  if [[ "${host}" == "${port}" ]]; then port="443"; fi

  # Pull cert, extract notAfter
  local enddate
  enddate="$(
    echo | openssl s_client -servername "${host}" -connect "${host}:${port}" 2>/dev/null \
      | openssl x509 -noout -enddate 2>/dev/null \
      | cut -d= -f2
  )"

  if [[ -z "${enddate}" ]]; then
    echo "FAIL  ${host}:${port}  (could not read certificate)"
    return 0
  fi

  local end_epoch now_epoch days_left
  end_epoch="$(date -d "${enddate}" +%s)"
  now_epoch="$(date +%s)"
  days_left="$(( (end_epoch - now_epoch) / 86400 ))"

  if (( days_left <= WARN_DAYS )); then
    echo "WARN  ${host}:${port}  expires_in=${days_left}d  end='${enddate}'"
  else
    echo "OK    ${host}:${port}  expires_in=${days_left}d  end='${enddate}'"
  fi
}

while IFS= read -r line; do
  [[ -z "${line}" ]] && continue
  [[ "${line}" =~ ^[[:space:]]*# ]] && continue
  check_one "${line}"
done < "${DOMAINS_FILE}"

---

