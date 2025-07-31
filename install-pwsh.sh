#!/usr/bin/env bash
#
# install-pwsh.sh — install PowerShell on major Linux distributions
# Usage: curl -sSL https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/install-pwsh.sh |
#        sudo bash

set -e

# Detect OS and version
if [ -r /etc/os-release ]; then
    . /etc/os-release
else
    echo "Cannot detect OS type. /etc/os-release not found." >&2
    exit 1
fi

echo "Detected OS: $NAME $VERSION_ID"

case "$ID" in
  ubuntu|debian)
    echo "Installing PowerShell via apt..."
    # Install prerequisites
    apt-get update -y
    apt-get install -y wget apt-transport-https software-properties-common
    # Import Microsoft repository GPG keys
    wget -O- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    # Register the repo
    DISTRO="${ID}_${VERSION_ID%.*}"
    add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/microsoft-${ID}-${VERSION_ID%.*}-prod $(lsb_release -cs) main"
    # Install PowerShell
    apt-get update -y
    apt-get install -y powershell
    ;;

  rhel|centos|rocky|almalinux)
    echo "Installing PowerShell via yum/dnf..."
    # Install prerequisites
    yum install -y wget
    # Import Microsoft repository for RHEL-compatible distro version
    RHELVER=${VERSION_ID%%.*}
    if [ "$RHELVER" -lt 8 ]; then RHELVER=7; fi
    rpm -Uvh https://packages.microsoft.com/config/rhel/${RHELVER}/packages-microsoft-prod.rpm
    # Install PowerShell
    if command -v dnf >/dev/null 2>&1; then
        dnf install -y powershell
    else
        yum install -y powershell
    fi
    ;;

  fedora)
    echo "Installing PowerShell via dnf..."
    dnf install -y wget
    rpm -Uvh https://packages.microsoft.com/config/fedora/$(rpm -E %fedora)/packages-microsoft-prod.rpm
    dnf install -y powershell
    ;;

  *)
    echo "Unsupported distribution: $ID" >&2
    exit 1
    ;;
esac

echo "PowerShell installation complete. Launch with 'pwsh'."
