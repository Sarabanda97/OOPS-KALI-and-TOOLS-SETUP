#!/usr/bin/env bash
set -Eeuo pipefail

printf '=== Updating OOPS workstation ===\n'
sudo apt update
sudo apt upgrade -y

command -v semgrep >/dev/null 2>&1 && pipx upgrade semgrep || true
command -v schemathesis >/dev/null 2>&1 && pipx upgrade schemathesis || true

export PATH="$PATH:$HOME/go/bin"
if command -v go >/dev/null 2>&1; then
  go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
fi
command -v nuclei >/dev/null 2>&1 && nuclei -update-templates || true

for repo in PayloadsAllTheThings testssl.sh jwt_tool; do
  [ -d "$HOME/pentest/tools/$repo/.git" ] && git -C "$HOME/pentest/tools/$repo" pull --ff-only || true
done

if [ -x "$HOME/pentest/tools/jwt_tool/.venv/bin/pip" ]; then
  "$HOME/pentest/tools/jwt_tool/.venv/bin/pip" install --upgrade pip
  "$HOME/pentest/tools/jwt_tool/.venv/bin/pip" install -r "$HOME/pentest/tools/jwt_tool/requirements.txt"
fi

sudo apt install --only-upgrade -y trivy 2>/dev/null || true

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck disable=SC1090
  . "$NVM_DIR/nvm.sh"
  nvm install --lts
fi

printf '\nUpdate completed. Run ./kali/verify-oops-tools.sh\n'
