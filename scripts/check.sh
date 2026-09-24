#!/usr/bin/env bash
# Check formulae the way Homebrew would: style, audit, install, test.
# Without arguments every formula in Formula/ is checked; naming formulae
# checks only those. Runs on a GitHub runner or on any machine with
# Homebrew; the checkout is linked into Homebrew's tap directory so the
# working tree is what gets checked, committed or not.
#
# A formula limited to another operating system or CPU gets style and
# audit only: Homebrew refuses to install it here.
#
# Style and audit leave out FormulaAudit/ComponentsOrder: that cop allows
# a url only at the top of a formula or inside a resource, and a formula
# that installs a release's binaries for several platforms names one url
# per platform.
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
elif [[ "$(cd "${taps}/homebrew-tap" && pwd -P)" != "$(cd "${here}" && pwd -P)" ]]; then
    echo "${tap} is installed from ${taps}/homebrew-tap, not from this checkout;" \
        "move that directory aside to check this checkout" >&2
    exit 1
fi
brew trust "${tap}"

formulae=()
files=()
if [[ $# -eq 0 ]]; then
    for file in "${here}"/Formula/*.rb; do
        formulae+=("${tap}/$(basename "${file}" .rb)")
        files+=("${file}")
    done
else
    for name in "$@"; do
        formulae+=("${tap}/${name}")
        files+=("${here}/Formula/${name}.rb")
    done
fi

os="$(uname -s)"
arch="$(uname -m)"
if [[ "${arch}" == aarch64 ]]; then
    arch=arm64
fi

# Print the requirements of a formula that this system does not meet, one
# per line: the operating system or the CPU the formula is limited to.
unmet() {
    brew info --json=v2 --formula "${1}" | jq -r --arg os "${os}" --arg arch "${arch}" '
        .formulae[0].requirements[]
        | select((.name == "macos" and $os != "Darwin")
              or (.name == "linux" and $os != "Linux")
              or (.name == "arch" and .version != $arch))
        | if .name == "arch" then .version else .name end'
}

brew style --except-cops FormulaAudit/ComponentsOrder "${files[@]}"
brew audit --except-cops FormulaAudit/ComponentsOrder "${formulae[@]}"
for formula in "${formulae[@]}"; do
    missing="$(unmet "${formula}")"
    if [[ -n "${missing}" ]]; then
        echo "${formula}: requires ${missing//$'\n'/ and }, not installed or tested here" >&2
        continue
    fi
    brew install --verbose "${formula}"
    brew test --verbose "${formula}"
done
