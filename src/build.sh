#!/bin/sh
# -----------------------------------------------------------------------------
# gh-clone-all - Build a .deb that installs a small CLI to clone all public 
#                GitHub repos for a user
# -----------------------------------------------------------------------------
# Purpose:  Package builder script that creates a Debian package containing the
#           `gh-clone-all` CLI. The installed CLI prompts for (or accepts as an
#           argument) a GitHub username and clones all public repos for that
#           user using the GitHub API.
#
# Usage:    ./build.sh
#           (produces gh-clone-all_1.0.0_all.deb)
#
# Example:  After installing the .deb, run:
#             gh-clone-all octocat
#           Or run without args and follow the prompt.
#
# Maintainer: brkln <github.com/brooks-code>
# Version:    1.0.0
# Architecture: all
# Dependencies (runtime): curl, git, awk, grep, sed, findutils
# License:    Unlicense
# Created:    2026-04-08
# -----------------------------------------------------------------------------

set -eu

PKG=gh-clone-all
VER=1.0.0
ARCH=all
ROOT="${PKG}_${VER}_${ARCH}"

rm -rf "$ROOT"
mkdir -p "$ROOT/DEBIAN" "$ROOT/usr/bin"

cat > "$ROOT/DEBIAN/control" <<'EOF'
Package: gh-clone-all
Version: 1.0.0
Section: utils
Priority: optional
Architecture: all
Maintainer: brkln <github.com/brooks-code>
Depends: curl, git, awk, grep, sed, findutils
Description: Clone all public GitHub repositories for a given username
 A simple helper that clones all public repositories 
 returned by the GitHub API for a specific username.
EOF

cat > "$ROOT/usr/bin/gh-clone-all" <<'EOF'
#!/bin/sh
set -eu

if [ "${1-}" ]; then
  USERNAME="$1"
else
  printf "Enter GitHub username: "
  read -r USERNAME
fi

curl -s "https://api.github.com/users/$USERNAME/repos?per_page=100" \
  | grep "clone_url" \
  | awk '{print $2}' \
  | sed -e 's/"//g' -e 's/,//g' \
  | xargs -n1 git clone
EOF

chmod 755 "$ROOT/usr/bin/gh-clone-all"

dpkg-deb --build "$ROOT"
