# VS Code + WSL

## Verify the WSL extension

In VS Code, open Extensions and confirm **WSL** by Microsoft is installed.

## Open a project from Kali

```bash
cd ~/pentest/projects/<repository>
code .
```

On first use, VS Code installs VS Code Server inside Kali. A successful compatibility check is expected.

The VS Code window should indicate a WSL/Kali connection. Open an integrated terminal and verify:

```bash
uname -a
which semgrep
which nuclei
which trivy
```

The paths should be Linux paths such as `/usr/bin/...`, `/usr/local/bin/...` or `/home/<user>/...`.

## Copilot

Confirm Copilot works while the repository is open through WSL. OOPS uses Copilot as an analysis accelerator for architecture, attack-surface and authorization mapping; generated conclusions still require human verification against the code and runtime behaviour.
