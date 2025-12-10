
#!/usr/bin/env bash
# Generate a random password of specified length with:
# - Uppercase letters
# - Lowercase letters
# - Digits
# - Special characters
#
# Usage:
#   ./genpass.sh <length>
#
# Example:
#   ./genpass.sh 24

set -euo pipefail

# Ensure predictable character handling
export LC_ALL=C

# Allowed character set (you can tweak specials to your policy needs)
LETTERS_UP='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
LETTERS_LO='abcdefghijklmnopqrstuvwxyz'
DIGITS='0123456789'
SPECIAL='!@#$%^&*_+=-'
CHARSET="${LETTERS_UP}${LETTERS_LO}${DIGITS}${SPECIAL}"

# Minimum length to reasonably include all categories
DEFAULT_LEN=16
MIN_LEN=8

LEN="${1:-$DEFAULT_LEN}"

# Ensure LEN is a positive integer
if ! [[ "$LEN" =~ ^[0-9]+$ ]]; then
  echo "Error: length must be an integer." >&2
  usage
  exit 1
fi

if (( LEN < MIN_LEN )); then
  echo "Error: length must be at least ${MIN_LEN}." >&2
  exit 1
fi

# Generate a candidate by sampling from /dev/urandom, restricting to CHARSET,
# and cutting to the desired length. Repeat until it meets policy.
generate_candidate() {
  # Read a bunch of random bytes, filter to the allowed charset, take first LEN chars
  tr -dc "$CHARSET" < /dev/urandom | head -c "$LEN"
}

meets_policy() {
  local pw="$1"
  # Must contain at least one uppercase, lowercase, digit, and special
  [[ "$pw" =~ [A-Z] ]] && \
  [[ "$pw" =~ [a-z] ]] && \
  [[ "$pw" =~ [0-9] ]] && \
  [[ "$pw" =~ [\!\@\#\$\%\^\&\*\_\+\=\-] ]]
}

# Try up to a reasonable number of iterations (extremely unlikely to need many)
max_tries=100
for ((i=1; i<=max_tries; i++)); do
  pw="$(generate_candidate || true)"
  # If the pipeline produced fewer than LEN chars (rare), regenerate
  if (( ${#pw} != LEN )); then
    continue
  fi
  if meets_policy "$pw"; then
    echo "$pw"
    exit 0
  fi
done

echo "Error: failed to generate a password meeting policy after $max_tries attempts." >&2
exit 2
