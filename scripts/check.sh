#!/usr/bin/env bash
# Check every formula in this checkout the way Homebrew would: style,
# audit, install, test. Runs on a GitHub runner or on any machine with
# Homebrew; the checkout is linked into Homebrew's tap directory so the
# working tree is what gets checked, committed or not.
#
# Style and audit leave out FormulaAudit/ComponentsOrder: that cop allows
# a url only at the top of a formula or inside a resource, and a formula
# that installs a release's binaries names one url per platform.
set -euo pipefail

# GitHub's Ubuntu runners have Homebrew installed but not on the PATH.
if ! command -v brew >/dev/null && [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

tap="sniner/tap"
here="$(cd "$(dirname "${0}")/.." && pwd)"
taps="$(brew --repository)/Library/Taps/sniner"

mkdir -p "${taps}"
if [[ ! -e "${taps}/homebrew-tap" ]]; then
    ln -s "${here}" "${taps}/homebrew-tap"
fi
brew trust "${tap}"

formulae=()
for file in "${here}"/Formula/*.rb; do
    formulae+=("${tap}/$(basename "${file}" .rb)")
done

brew style --except-cops FormulaAudit/ComponentsOrder "${here}/Formula"
brew audit --except-cops FormulaAudit/ComponentsOrder "${formulae[@]}"
for formula in "${formulae[@]}"; do
    brew install --verbose "${formula}"
    brew test --verbose "${formula}"
done
