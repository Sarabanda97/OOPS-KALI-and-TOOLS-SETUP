# Caido + Firefox

Use a dedicated Firefox profile for assessment traffic.

## Basic setup

1. Start Caido.
2. Configure the dedicated Firefox profile to proxy through Caido, or use Caido's supported browser workflow.
3. Install/trust the Caido CA certificate only in the dedicated testing profile as required.
4. Browse to an HTTPS development target that is in scope.
5. Confirm the request appears in Caido HTTP History.
6. Send a request to Replay and confirm it can be modified and resent.

Do not install interception CAs into unrelated personal browser profiles unless there is a specific operational reason.
