FILE: linux/shell-and-bash/scripts/account/user_account_mgmt.sh
===============================================================================

#!/usr/bin/env bash
set -euo pipefail

# user_account_mgmt.sh
# Usage:
#   sudo ./user_account_mgmt.sh create <username> [shell] [home]
#   sudo ./user_account_mgmt.sh delete <username>
#   sudo ./user_account_mgmt.sh passwd <username>
#   ./user_account_mgmt.sh list
#   ./user_account_mgmt.sh info <username>
#
# Notes:
# - Actions that modify users require root.
# - Designed for LFCS practice: useradd/usermod/userdel/passwd/id/getent.

ACTION="${1:-}"
USERNAME="${2:-}"

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "ERROR: must run as root for this action." >&2
    exit 1
  fi
}

user_exists() {
  id "$1" >/dev/null 2>&1
}

usage() {
  echo "Usage:"
  echo "  sudo $0 create <username> [shell] [home]"
  echo "  sudo $0 delete <username>"
  echo "  sudo $0 passwd <username>"
  echo "  $0 list"
  echo "  $0 info <username>"
}

create_user() {
  require_root

  local shell="${3:-/bin/bash}"
  local home="${4:-/home/${USERNAME}}"

  if [[ -z "${USERNAME}" ]]; then
    echo "ERROR: username required." >&2
    exit 1
  fi

  if user_exists "${USERNAME}"; then
    echo "ERROR: user '${USERNAME}' already exists." >&2
    exit 1
  fi

  useradd -m -d "${home}" -s "${shell}" "${USERNAME}"
  echo "OK: created user '${USERNAME}' (home=${home}, shell=${shell})"
}

delete_user() {
  require_root

  if [[ -z "${USERNAME}" ]]; then
    echo "ERROR: username required." >&2
    exit 1
  fi

  if ! user_exists "${USERNAME}"; then
    echo "ERROR: user '${USERNAME}' does not exist." >&2
    exit 1
  fi

  userdel -r "${USERNAME}"
  echo "OK: deleted user '${USERNAME}'"
}

set_password() {
  require_root

  if [[ -z "${USERNAME}" ]]; then
    echo "ERROR: username required." >&2
    exit 1
  fi

  if ! user_exists "${USERNAME}"; then
    echo "ERROR: user '${USERNAME}' does not exist." >&2
    exit 1
  fi

  passwd "${USERNAME}"
}

list_users() {
  # Human-friendly list of local users
  getent passwd | awk -F: '{printf "%-20s %s\n",$1,$6}'
}

user_info() {
  if [[ -z "${USERNAME}" ]]; then
    echo "ERROR: username required." >&2
    exit 1
  fi

  if ! user_exists "${USERNAME}"; then
    echo "ERROR: user '${USERNAME}' does not exist." >&2
    exit 1
  fi

  id "${USERNAME}"
  getent passwd "${USERNAME}"
}

case "${ACTION}" in
  create) create_user "$@" ;;
  delete) delete_user ;;
  passwd) set_password ;;
  list)   list_users ;;
  info)   user_info ;;
  *)      usage; exit 1 ;;
esac

