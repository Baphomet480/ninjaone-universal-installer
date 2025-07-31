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
    # Prerequisites

    # Update the list of packages
    apt-get update -y

    # Install pre-requisite packages
    apt-get install -y wget apt-transport-https software-properties-common

    # Get the version of Ubuntu
    source /etc/os-release

    # Download the Microsoft repository keys
    wget -q https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb

    # Register the Microsoft repository keys
    dpkg -i packages-microsoft-prod.deb

    # Delete the Microsoft repository keys file
    rm -f packages-microsoft-prod.deb

    # Update the list of packages after adding packages.microsoft.com
    apt-get update -y

    # Install PowerShell
    apt-get install -y powershell
    ;;

  rhel|centos|rocky|almalinux)
    echo "Installing PowerShell via yum/dnf..."
    # Prerequisites

    # Get version of RHEL
    source /etc/os-release
    if [ ${VERSION_ID%.*} -lt 8 ]
    then majorver=7
    elif [ ${VERSION_ID%.*} -lt 9 ]
    then majorver=8
    else majorver=9
    fi

    # Download the Microsoft RedHat repository package
    curl -sSL -O https://packages.microsoft.com/config/rhel/$majorver/packages-microsoft-prod.rpm

    # Register the Microsoft RedHat repository
    rpm -i packages-microsoft-prod.rpm

    # Delete the downloaded package after installing
    rm -f packages-microsoft-prod.rpm

    # Update package index files and install PowerShell
    dnf update -y
    dnf install -y powershell
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
