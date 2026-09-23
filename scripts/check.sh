#!/usr/bin/env bash
# Check every formula in this checkout the way Homebrew would: audit,
# style, install, test. Runs on a GitHub runner or on any machine with
# Homebrew; the checkout is linked into Homebrew's tap directory so the
# working tree is what gets checked, committed or not.
set -euo pipefail

tap="sniner/tap"
here="$(cd "$(dirname "$0")/.." && pwd)"
taps="$(brew --repository)/Library/Taps/sniner"

mkdir -p "$taps"
if [ ! -e "$taps/homebrew-tap" ]; then
    ln -s "$here" "$taps/homebrew-tap"
fi

formulae=()
for file in "$here"/Formula/*.rb; do
    formulae+=("$tap/$(basename "$file" .rb)")
done

brew style "$tap"
brew audit --strict "${formulae[@]}"
for formula in "${formulae[@]}"; do
    brew install --verbose "$formula"
    brew test --verbose "$formula"
done
