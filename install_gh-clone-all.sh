#!/bin/bash
######################################################################
# Name:         install_gh-clone-all.sh
#
# Description:  This script automates the process of downloading and
#               installing a package from a GitHub release.
#
# Details:
#   - It constructs the download URL based on the repository name,
#     package name, and version.
#   - Uses curl to download the .deb package.
#   - Installs the package using dpkg, and if there are dependency issues,
#     attempts to correct them using apt-get.
#   - Cleans up by removing the downloaded package file.
#   - Runs the installed software.
#
# Requirements:
#   - curl, dpkg, and apt-get must be available on the system.
#   - The script must be run with sufficient privileges to install packages.
#
# Usage:
#   Run this script to automatically download and install the specified
#   package from its GitHub release URL.
#
# Author:       github.com/brooks-code
# Date:         2026-04-06
# Listening:    Any other name by Thomas Newman (1999)
######################################################################
set -e

REPO="brooks-code/clone-github-user-repos"
VERSION="v1.0.0"
PKG="gh-clone-all_${VERSION#v}_all.deb"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${PKG}"
CMD="gh-clone-all"

echo "Downloading ${PKG} from ${DOWNLOAD_URL}..."
curl -L -o "${PKG}" "${DOWNLOAD_URL}"

# Try installing; if dependencies fail, attempt to fix and reinstall
echo "Installing ${PKG}..."
if sudo dpkg -i "${PKG}"; then
  INSTALL_OK=1
else
  sudo apt-get update
  if sudo apt-get install -f -y && sudo dpkg -i "${PKG}"; then
    INSTALL_OK=1
  else
    INSTALL_OK=0
  fi
fi

echo "Cleaning up the package..."
rm -f "${PKG}"

if [ "${INSTALL_OK}" -eq 1 ]; then
  echo "Installation successful!"
  echo "Running ${CMD} once... (hit ctrl + C to abort)."
else
  echo "Installation failed." >&2
  exit 1
fi
