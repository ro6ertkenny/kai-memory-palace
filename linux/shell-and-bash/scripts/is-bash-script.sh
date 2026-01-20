===============================================================================
FILE: linux/shell-and-bash/scripts/analysis/is-bash-script.sh
===============================================================================

#!/usr/bin/env bash
set -euo pipefail

# is-bash-script.sh
# Usage:
#   ./is-bash-script.sh <file>
#
# Returns:
# - exit 0 if file looks like a bash script by shebang
# - exit 1 otherwise

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <file>" >&2
  exit 1
fi

file="$1"

if [[ ! -r "$file" ]]; then
  echo "ERROR: '$file' is not readable or does not exist." >&2
  exit 1
fi

first_line="$(head -n 1 "$file" || true)"

if echo "$first_line" | grep -Eq '^#! */bin/bash|^#! */usr/bin/env +bash'; then
  echo "YES: '$file' looks like a bash script."
  exit 0
else
  echo "NO:  '$file' does not look like a bash script."
  exit 1
fi

---
