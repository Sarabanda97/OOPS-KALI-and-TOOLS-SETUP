#!/usr/bin/env bash
set -u

PASS=0
FAIL=0

ok() { printf '\033[1;32m[OK]\033[0m   %s\n' "$1"; PASS=$((PASS+1)); }
bad() { printf '\033[1;31m[FAIL]\033[0m %s\n' "$1"; FAIL=$((FAIL+1)); }
check_cmd() { if command -v "$1" >/dev/null 2>&1; then ok "$2 ($(command -v "$1"))"; else bad "$2"; fi; }

printf 'OOPS Workstation Verification\n=============================\n'

printf '\nBase\n----\n'
check_cmd git Git
check_cmd python3 Python
check_cmd pipx pipx
check_cmd go Go
check_cmd java Java
check_cmd node Node.js
check_cmd npm npm

printf '\nRecon\n-----\n'
check_cmd nmap Nmap
check_cmd ffuf ffuf
check_cmd whatweb WhatWeb
[ -d /usr/share/seclists ] && ok "SecLists (/usr/share/seclists)" || bad "SecLists"

printf '\nStatic analysis\n---------------\n'
check_cmd semgrep Semgrep
check_cmd gitleaks Gitleaks
check_cmd trivy Trivy

printf '\nDynamic\n-------\n'
check_cmd nuclei Nuclei
[ -d "$HOME/nuclei-templates" ] && ok "Nuclei templates" || bad "Nuclei templates"
[ -x "$HOME/pentest/tools/testssl.sh/testssl.sh" ] && ok "testssl.sh" || bad "testssl.sh"
check_cmd nikto Nikto

printf '\nAPI\n---\n'
check_cmd http HTTPie
check_cmd jq jq
check_cmd schemathesis Schemathesis
[ -f "$HOME/pentest/tools/jwt_tool/jwt_tool.py" ] && [ -x "$HOME/pentest/tools/jwt_tool/.venv/bin/python" ] && ok "jwt_tool" || bad "jwt_tool"

printf '\nPayloads\n--------\n'
[ -d "$HOME/pentest/tools/PayloadsAllTheThings/.git" ] && ok "PayloadsAllTheThings" || bad "PayloadsAllTheThings"

printf '\nCode mapping\n------------\n'
check_cmd doxygen Doxygen
check_cmd dot Graphviz

printf '\nCloud / Kubernetes\n------------------\n'
check_cmd az "Azure CLI"
check_cmd kubectl kubectl
check_cmd kubectx kubectx
check_cmd kubens kubens
check_cmd helm Helm

printf '\nDocker / WSL integration\n------------------------\n'
if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then ok "Docker CLI + daemon"; else bad "Docker CLI found but daemon unavailable"; fi
else
  bad "Docker CLI (enable Docker Desktop WSL integration)"
fi

printf '\nSummary\n-------\n'
printf 'Passed: %d\nFailed: %d\n' "$PASS" "$FAIL"

if [ "$FAIL" -eq 0 ]; then
  printf '\033[1;32mOverall status: READY\033[0m\n'
  exit 0
else
  printf '\033[1;33mOverall status: ATTENTION REQUIRED\033[0m\n'
  exit 1
fi
