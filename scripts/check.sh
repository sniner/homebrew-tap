#!/usr/bin/env bash
# Check every formula in this checkout the way Homebrew would: style,
# audit, install, test. Runs on a GitHub runner or on any machine with
# Homebrew; the checkout is linked into Homebrew's tap directory so the
# working tree is what gets checked, committed or not.
#
# The audit leaves out FormulaAudit/ComponentsOrder: that cop allows a
# url only at the top of a formula or inside a resource, and a formula
# that installs a release's binaries names one url per platform.
set -euo pipefail

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

brew style "${here}/Formula"
brew audit --strict --except-cops FormulaAudit/ComponentsOrder "${formulae[@]}"
for formula in "${formulae[@]}"; do
    brew install --verbose "${formula}"
    brew test --verbose "${formula}"
done
