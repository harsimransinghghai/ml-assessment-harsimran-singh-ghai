#!/bin/bash
set -euo pipefail

# Only run in remote cloud environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Set up Playwright MCP with Microsoft Edge (Playwright CDN is blocked in this environment)

# 1. Add Microsoft Edge apt repo if not already present
if ! dpkg -l microsoft-edge-stable &>/dev/null; then
  curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
  install -o root -g root -m 644 /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" \
    > /etc/apt/sources.list.d/microsoft-edge-stable.list
  apt-get update -qq
  apt-get install -y microsoft-edge-stable
fi

# 2. Create the Chrome wrapper Playwright expects at /opt/google/chrome/chrome
mkdir -p /opt/google/chrome
if [ ! -f /opt/google/chrome/chrome ] || ! grep -q "ignore-certificate-errors" /opt/google/chrome/chrome; then
  tee /opt/google/chrome/chrome > /dev/null << 'WRAPPER'
#!/bin/bash
exec /opt/microsoft/msedge/microsoft-edge --ignore-certificate-errors "$@"
WRAPPER
  chmod +x /opt/google/chrome/chrome
fi
