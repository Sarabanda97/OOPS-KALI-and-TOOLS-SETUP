# Troubleshooting

## `helm`: Unable to locate package

Do not depend on `apt install helm` on Kali. The setup script uses Helm's installer.

## testssl.sh: `You need to install hexdump`

Install:

```bash
sudo apt install -y bsdextrautils
```

Then:

```bash
~/pentest/tools/testssl.sh/testssl.sh --version
```

## Node/npm resolves to Windows

Check:

```bash
which node
which npm
```

With NVM, both should normally resolve under:

```text
/home/<user>/.nvm/versions/node/...
```

If they resolve under `/mnt/c/...`, reload the Linux shell and make sure NVM is loaded.

## Nuclei appears blank in a script

Nuclei may print version information to stderr. Test it directly:

```bash
nuclei -version
```

## VS Code installs VS Code Server

This is expected the first time `code .` is run from WSL. A `Compatibility check successful` message indicates the server installation succeeded.

## Docker command not found / daemon unavailable

Open Docker Desktop and enable **Settings → Resources → WSL Integration → Kali Linux**.

Then retry:

```bash
docker --version
docker run --rm hello-world
```

## kubectl has no context

Installing kubectl does not configure company clusters. Kubeconfig/context access must be obtained through the approved corporate process. Do not copy credentials from another user.
