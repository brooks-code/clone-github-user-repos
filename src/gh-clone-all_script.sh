#!/bin/sh
# gh-clone-all_script.sh - Clone all public GitHub repositories for a given user
# -----------------------------------------------------------------------------
# Purpose:  One-line pipeline to fetch and clone all public repos for a GitHub
#           username using the GitHub API.
#
# Usage:    Replace USERNAME in the URL or pass a substitution before running:
#             USERNAME=octocat ./gh-clone-all_script.sh
#           Or edit the URL to include your username.
#
# Notes:    - GitHub API is rate-limited for unauthenticated requests.
#           - This clones up to 100 repos (per_page=100); paginate for more.
#           - Requires: curl, grep, awk, sed, xargs (findutils), git
#
# Version:  1.0
# Author:   Artémis ft. Euthymie
# Created:  2026-04-01
# Location: Bateau de Thésée
# -----------------------------------------------------------------------------

# Replace your USERNAME
curl -s "https://api.github.com/users/USERNAME/repos?per_page=100" \
| grep "clone_url" \
| awk '{print $2}' \
| sed -e 's/"//g' -e 's/,//g' \
| xargs -n1 git clone
