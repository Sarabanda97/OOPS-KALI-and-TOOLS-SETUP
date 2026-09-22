# OOPS Kali & Tools Setup

Bootstrap and configuration for the standard workstation used with the **OOPS — Offensive Operations & Product Security** framework.

The goal is simple: a new team member should be able to start from a Windows 11 machine, install Kali on WSL2, install the standard security tooling, configure the Windows-side applications, and verify that the workstation is ready for internal Web and API assessments.

## Quick start

### 1. Windows — install WSL2 and Kali

Open **PowerShell as Administrator** from the repository folder:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\windows\install-wsl.ps1
```

Restart Windows if requested. Open Kali and create the Linux username/password when prompted.

### 2. Clone this repository inside Kali

```bash
mkdir -p ~/pentest/projects
cd ~/pentest/projects
git clone https://github.com/Sarabanda97/OOPS-KALI-and-TOOLS-SETUP.git
cd OOPS-KALI-and-TOOLS-SETUP
```

### 3. Install the Kali toolset

```bash
chmod +x kali/*.sh
./kali/setup-oops-tools.sh
```

### 4. Reload the shell

```bash
exec $SHELL -l
```

### 5. Verify

```bash
./kali/verify-oops-tools.sh
```

### 6. Finish the Windows-side setup

- [Windows applications](docs/windows-setup.md)
- [VS Code + WSL](docs/vscode-wsl.md)
- [Docker Desktop + WSL](docs/docker-wsl.md)
- [Caido + Firefox](docs/caido-firefox.md)

## Installed Kali toolset

| Area | Tools |
|---|---|
| Base | Git, curl, wget, jq, Python, pipx, Go, Java |
| Recon | Nmap, ffuf, WhatWeb, SecLists |
| Static | Semgrep, Gitleaks, Trivy |
| Dynamic | Nuclei, testssl.sh, Nikto |
| API | HTTPie, Schemathesis, jwt_tool |
| Payloads | PayloadsAllTheThings, SecLists |
| Code mapping | Doxygen, Graphviz |
| Cloud/Kubernetes | Azure CLI, kubectl, kubectx, kubens, Helm |
| Runtime | Node.js LTS via NVM |

## Workspace

The installer creates:

```text
~/pentest/
├── tools/
├── projects/
├── results/
├── evidence/
└── wordlists/
```

Target repositories should normally be cloned under `~/pentest/projects`, not `/mnt/c`, to avoid WSL filesystem and tooling issues.

## Updating

```bash
./kali/update-oops-tools.sh
./kali/verify-oops-tools.sh
```

## Important

- This repository prepares a workstation. It does **not** authorize testing of any target.
- Only run scanners, fuzzers or exploitation tooling against systems explicitly included in the assessment scope.
- Production testing must follow the assessment Rules of Engagement and OOPS production-safe restrictions.
- Never commit real secrets, access tokens, customer data or pentest evidence here.
- Acunetix Premium is company-provided and intentionally not installed by these scripts.

## Repository layout

```text
.
├── README.md
├── windows/
│   └── install-wsl.ps1
├── kali/
│   ├── setup-oops-tools.sh
│   ├── update-oops-tools.sh
│   └── verify-oops-tools.sh
├── docs/
│   ├── windows-setup.md
│   ├── vscode-wsl.md
│   ├── docker-wsl.md
│   ├── caido-firefox.md
│   └── troubleshooting.md
└── .gitignore
```
