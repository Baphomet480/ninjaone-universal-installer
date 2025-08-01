#!/usr/bin/env bash
# Version: 0.1.0
set -euo pipefail

###############################################################################
# install-ninja.sh – bootstrap PowerShell on RHEL / Rocky, then run the
# ninja-universal.ps1 installer with whatever args you supply after "--".
#
# usage examples
#   sudo bash install-ninja.sh -- -Install -ClientId 'xxx' -ClientSecret 'yyy'
#   sudo bash install-ninja.sh -- -Region EU -Install
#   curl -sSL https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/install-ninja.sh \
#     | sudo bash -- -Install -ClientId 'xxx' -ClientSecret 'yyy'
###############################################################################

# ── locate RHEL major version ───────────────────────────────────────────
source /etc/os-release
if   [ "${VERSION_ID%%.*}" -lt 8 ]; then majorver=7
elif [ "${VERSION_ID%%.*}" -lt 9 ]; then majorver=8
else majorver=9
fi

# ── add Microsoft repo if missing ───────────────────────────────────────
if ! rpm -q packages-microsoft-prod &>/dev/null; then
  echo "[INFO] Adding Microsoft repo for RHEL $majorver …"
  curl -fsSL -O "https://packages.microsoft.com/config/rhel/$majorver/packages-microsoft-prod.rpm"
  sudo rpm -i packages-microsoft-prod.rpm
  rm -f packages-microsoft-prod.rpm
fi

# ── update repo metadata & install PowerShell 7 ─────────────────────────
sudo dnf -y update
if ! command -v pwsh &>/dev/null; then
  echo "[INFO] Installing PowerShell 7 …"
  sudo dnf install -y powershell
else
  echo "[INFO] PowerShell already present: $(pwsh -v)"
fi

# ── fetch the latest ninja-universal.ps1 (cache-bust with time stamp) ──
TMP_PS1="/tmp/ninja-universal.ps1"
curl -fsSL \
     "https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1?$(date +%s)" \
     -o "$TMP_PS1"

# ── run the PowerShell script, forwarding any extra CLI args ────────────
echo "[INFO] Launching ninja-universal.ps1 $*"
# Ensure interactive prompts work even when this script was piped via stdin
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "$TMP_PS1" "$@" </dev/tty
