# Docker Desktop + Kali WSL

1. Open Docker Desktop.
2. Go to **Settings → Resources → WSL Integration**.
3. Enable integration with Kali Linux.
4. Apply/restart Docker Desktop if requested.

From Kali:

```bash
docker --version
docker run --rm hello-world
```

Both commands must succeed. If `docker` exists but cannot connect to the daemon, check that Docker Desktop is running and that Kali is enabled in WSL Integration.
