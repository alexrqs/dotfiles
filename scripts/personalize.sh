#!/bin/bash
# Prompt for personal/work git identities and write ~/.temp with `me`
# and `work` shell functions. Not committed; runs once per machine.

set -euo pipefail

TEMP_FILE="$HOME/.temp"

if [ -f "$TEMP_FILE" ]; then
  read -p "$TEMP_FILE already exists. Overwrite? [y/N]: " -n 1 -r; echo
  [[ $REPLY =~ ^[Yy]$ ]] || { echo "Aborted, leaving $TEMP_FILE alone."; exit 0; }
fi

read -rp "Personal email: " email
read -rp "Personal git user: " user
read -rp "Work email: " workEmail
read -rp "Work git user: " workUser

cat > "$TEMP_FILE" <<EOF
#!/bin/bash

function me() {
  git config user.email "$email"
  git config user.name  "$user"
  echo "local email \$(git config user.email)"
  echo "local user  \$(git config user.name)"
}

function work() {
  git config user.email "$workEmail"
  git config user.name  "$workUser"
  echo "local email \$(git config user.email)"
  echo "local user  \$(git config user.name)"
}
EOF

echo "✓ wrote $TEMP_FILE — run 'source ~/.temp' or open a new shell."
