# Windows setup

The Kali scripts only configure the WSL side. The following applications are expected on Windows.

## Required

- **VS Code**
- **VS Code WSL extension**
- **GitHub Copilot / Copilot Chat** using the company account
- **Caido**
- **Firefox** with a dedicated pentest profile
- **Docker Desktop**
- **Acunetix Premium access** supplied by the company

## Recommended

- Burp Suite Community — useful for PortSwigger Academy material and as a second proxy/repeater
- Bruno — convenient local/API collection workflow

## Firefox profile

Do not use a personal browsing profile for testing.

1. Open Firefox.
2. Go to `about:profiles`.
3. Create `OOPS Pentest`.
4. Use it only for assessment accounts, proxy CAs and test cookies.

For authorization testing, separate profiles or containers for User A, User B and Admin are useful.

## Acunetix

Acunetix is not installed by the Kali script. Confirm that you can access the corporate instance and, where relevant, create targets, configure authenticated scans and import OpenAPI/Swagger definitions.
