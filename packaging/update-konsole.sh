#!/bin/bash
# SPDX-FileCopyrightText: 2026 Eric Duprey <509630+destinal@users.noreply.github.com>
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Moves the Claude Code patches to another Konsole release.
#
#   update-konsole.sh 26.08.2
#
# Fetches the release's tag into the Konsole checkout ($KONSOLE_SOURCE, by
# default ../konsole: a clone of https://github.com/destinal/konsole with the
# claude-integration branch), rebases that branch onto it, builds and runs the
# tests, then refreshes the patches here and the PKGBUILD's version and
# checksums. Stops at the first failure; a rebase conflict is left for you to
# resolve (then run the script again).
set -euo pipefail

version=${1:?usage: update-konsole.sh VERSION}
here=$(cd "$(dirname "$0")" && pwd)
konsole=${KONSOLE_SOURCE:-$here/../konsole}
current=$(sed -n 's/^pkgver=//p' "$here/PKGBUILD")

cd "$konsole"
git fetch --quiet --depth 100 origin tag "v$version"
if [ "$version" != "$current" ]; then
    git rebase --onto "v$version" "v$current" claude-integration
fi

cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TESTING=ON >/dev/null
cmake --build build
# TerminalInterfaceTest fails the same way on unpatched Konsole here.
QT_QPA_PLATFORM=offscreen ctest --test-dir build --output-on-failure -E TerminalInterfaceTest

rm -f "$here"/[0-9][0-9][0-9][0-9]-*.patch
git format-patch --quiet "v$version..claude-integration" -o "$here"

cd "$here"
sed -i "s/^pkgver=.*/pkgver=$version/; s/^pkgrel=.*/pkgrel=1/" PKGBUILD
updpkgsums
echo "Konsole $version with $(ls "$here"/[0-9][0-9][0-9][0-9]-*.patch | wc -l) patches. Build with: makepkg -s"
