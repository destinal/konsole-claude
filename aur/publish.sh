#!/bin/bash
# SPDX-FileCopyrightText: 2026 Eric Duprey <509630+destinal@users.noreply.github.com>
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Publishes this directory's PKGBUILD to the AUR as konsole-claude.
#
# Needs an AUR account whose SSH key is this machine's. Regenerates
# .SRCINFO, clones the AUR repository, copies in the three files it holds,
# and pushes them as a commit named after the package version.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
cd "$here"
makepkg --printsrcinfo > .SRCINFO
version=$(sed -n 's/^\tpkgver = //p' .SRCINFO)-$(sed -n 's/^\tpkgrel = //p' .SRCINFO)

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
git clone --quiet ssh://aur@aur.archlinux.org/konsole-claude.git "$work/aur"
cp PKGBUILD .SRCINFO konsole-claude.install "$work/aur/"
cd "$work/aur"
git config user.name "Eric Duprey"
git config user.email "509630+destinal@users.noreply.github.com"
git add PKGBUILD .SRCINFO konsole-claude.install
if git diff --cached --quiet; then
    echo "The AUR already has konsole-claude $version."
    exit 0
fi
git commit --quiet -m "konsole-claude $version"
git push --quiet origin HEAD:master
echo "Published konsole-claude $version: https://aur.archlinux.org/packages/konsole-claude"
