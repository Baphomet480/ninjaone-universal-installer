#!/usr/bin/env bash
# Version: 0.1.3
set -euo pipefail

###############################################################################
# install-ninja.sh – bootstrap PowerShell on RHEL / Rocky, then run the
# ninja-universal.ps1 installer with whatever args you supply after "--".
#
# usage examples
#   sudo bash install-ninja.sh -- -Install -ClientId 'xxx' -ClientSecret 'yyy'
#   sudo bash install-ninja.sh -- -Region EU -Install
#   curl -sSL https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/install-ninja.sh \
#     | sudo bash -s -- -Install -ClientId 'xxx' -ClientSecret 'yyy'
###############################################################################

# ==========================================================================
# Bootstrap PowerShell installation on Debian/Ubuntu or RHEL-based systems
# ==========================================================================
source /etc/os-release
if command -v apt-get &>/dev/null; then
  echo "[INFO] Detecting Debian/Ubuntu: $NAME $VERSION_ID"
  # Prerequisites
  # Update package list (ignore any repository errors)
  apt-get update -y || true
  apt-get install -y wget apt-transport-https software-properties-common
  # Import Microsoft repository keys
  wget -q https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb
  dpkg -i packages-microsoft-prod.deb
  rm -f packages-microsoft-prod.deb
  # Install PowerShell
  # Refresh packages after registering MS repo (ignore any repository errors)
  apt-get update -y || true
  if ! command -v pwsh &>/dev/null; then
    echo "[INFO] Installing PowerShell …"
    apt-get install -y powershell
  else
    echo "[INFO] PowerShell already present: $(pwsh -v)"
  fi
else
  # RHEL/CentOS/Rocky/AlmaLinux
  if command -v dnf &>/dev/null || command -v yum &>/dev/null; then
    echo "[INFO] Detecting RHEL-based distro: $NAME $VERSION_ID"
    RHEL_MAJOR=${VERSION_ID%%.*}
    if [ "$RHEL_MAJOR" -lt 8 ]; then majorver=7
    elif [ "$RHEL_MAJOR" -lt 9 ]; then majorver=8
    else majorver=9
    fi
    if ! rpm -q packages-microsoft-prod &>/dev/null; then
      echo "[INFO] Adding Microsoft repo for RHEL $majorver …"
      curl -fsSL -O "https://packages.microsoft.com/config/rhel/$majorver/packages-microsoft-prod.rpm"
      rpm -i packages-microsoft-prod.rpm
      rm -f packages-microsoft-prod.rpm
    fi
    # Install PowerShell
    if command -v dnf &>/dev/null; then
      dnf update -y && dnf install -y powershell
    else
      yum update -y && yum install -y powershell
    fi
  fi
fi

# ── fetch the latest ninja-universal.ps1 (cache-bust with time stamp) ──
TMP_PS1="/tmp/ninja-universal.ps1"
curl -fsSL \
     -H 'Cache-Control: no-cache' \
     "https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1?$(date +%s)" \
     -o "$TMP_PS1"

# ── run the PowerShell script, forwarding any extra CLI args ────────────
echo "[INFO] Launching ninja-universal.ps1 $*"
# Ensure interactive prompts work even when this script was piped via stdin
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -Interactive -File "$TMP_PS1" "$@" </dev/tty
