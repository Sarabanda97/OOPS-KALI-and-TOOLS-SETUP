#!/usr/bin/env bash
set -Eeuo pipefail

TOOLS_DIR="$HOME/pentest/tools"
PROJECTS_DIR="$HOME/pentest/projects"

log() { printf '\n\033[1;36m[%s]\033[0m %s\n' "$1" "$2"; }
have() { command -v "$1" >/dev/null 2>&1; }

log "1/11" "Creating OOPS workspace"
mkdir -p "$HOME/pentest"/{tools,wordlists,projects,results,evidence}

log "2/11" "Installing Kali packages"
sudo apt update
sudo apt install -y \
  git curl wget jq unzip zip tar gzip ca-certificates gnupg lsb-release \
  python3 python3-pip python3-venv pipx build-essential \
  nmap netcat-openbsd dnsutils whois openssl \
  tree ffuf httpie whatweb nikto \
  doxygen graphviz default-jdk golang-go seclists bsdextrautils kubectx
pipx ensurepath || true

log "3/11" "Installing Semgrep"
if have semgrep; then pipx upgrade semgrep || true; else pipx install semgrep; fi

log "4/11" "Installing Trivy"
if ! have trivy; then
  wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/trivy.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
    | sudo tee /etc/apt/sources.list.d/trivy.list >/dev/null
  sudo apt update
  sudo apt install -y trivy
fi

log "5/11" "Installing Gitleaks"
if ! have gitleaks; then
  TMP_DIR="$(mktemp -d)"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64) GL_ARCH="x64" ;;
    aarch64|arm64) GL_ARCH="arm64" ;;
    *) echo "Unsupported architecture for automatic Gitleaks install: $ARCH"; exit 1 ;;
  esac
  GL_VERSION="$(curl -fsSL https://api.github.com/repos/gitleaks/gitleaks/releases/latest | jq -r '.tag_name' | sed 's/^v//')"
  curl -fsSL "https://github.com/gitleaks/gitleaks/releases/download/v${GL_VERSION}/gitleaks_${GL_VERSION}_linux_${GL_ARCH}.tar.gz" \
    -o "$TMP_DIR/gitleaks.tar.gz"
  tar -xzf "$TMP_DIR/gitleaks.tar.gz" -C "$TMP_DIR"
  sudo install -m 0755 "$TMP_DIR/gitleaks" /usr/local/bin/gitleaks
  rm -rf "$TMP_DIR"
fi

log "6/11" "Installing Nuclei"
export PATH="$PATH:$HOME/go/bin"
if ! have nuclei; then
  go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
fi
"$HOME/go/bin/nuclei" -update-templates || true

log "7/11" "Installing security repositories"
clone_or_update() {
  local url="$1" dir="$2"
  if [ -d "$dir/.git" ]; then git -C "$dir" pull --ff-only || true
  else git clone "$url" "$dir"
  fi
}
clone_or_update https://github.com/swisskyrepo/PayloadsAllTheThings.git "$TOOLS_DIR/PayloadsAllTheThings"
clone_or_update https://github.com/drwetter/testssl.sh.git "$TOOLS_DIR/testssl.sh"
clone_or_update https://github.com/ticarpi/jwt_tool.git "$TOOLS_DIR/jwt_tool"

python3 -m venv "$TOOLS_DIR/jwt_tool/.venv"
"$TOOLS_DIR/jwt_tool/.venv/bin/pip" install --upgrade pip
"$TOOLS_DIR/jwt_tool/.venv/bin/pip" install -r "$TOOLS_DIR/jwt_tool/requirements.txt"

log "8/11" "Installing Schemathesis"
if have schemathesis; then pipx upgrade schemathesis || true; else pipx install schemathesis; fi

log "9/11" "Installing Azure CLI, kubectl and Helm"
if ! have az; then curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash; fi

if ! have kubectl; then
  KVER="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
  TMP_DIR="$(mktemp -d)"
  curl -fsSLo "$TMP_DIR/kubectl" "https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl"
  curl -fsSLo "$TMP_DIR/kubectl.sha256" "https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl.sha256"
  (cd "$TMP_DIR" && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check)
  sudo install -m 0755 "$TMP_DIR/kubectl" /usr/local/bin/kubectl
  rm -rf "$TMP_DIR"
fi

if ! have helm; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

log "10/11" "Installing NVM and Node.js LTS"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck disable=SC1090
  . "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
fi

log "11/11" "Configuring shell"
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  touch "$rc"
  grep -qxF 'export PATH="$PATH:$HOME/go/bin"' "$rc" || echo 'export PATH="$PATH:$HOME/go/bin"' >> "$rc"
  grep -qxF "alias ll='ls -lah'" "$rc" || echo "alias ll='ls -lah'" >> "$rc"
  grep -qxF "alias pentest='cd ~/pentest'" "$rc" || echo "alias pentest='cd ~/pentest'" >> "$rc"
  grep -qxF "alias tools='cd ~/pentest/tools'" "$rc" || echo "alias tools='cd ~/pentest/tools'" >> "$rc"
  grep -qxF "alias projects='cd ~/pentest/projects'" "$rc" || echo "alias projects='cd ~/pentest/projects'" >> "$rc"
  grep -qxF "alias evidence='cd ~/pentest/evidence'" "$rc" || echo "alias evidence='cd ~/pentest/evidence'" >> "$rc"
done

printf '\n\033[1;32mOOPS setup completed.\033[0m\n'
printf 'Reload the shell with: exec $SHELL -l\n'
printf 'Then run: ./kali/verify-oops-tools.sh\n'
