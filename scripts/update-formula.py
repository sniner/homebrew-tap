#!/usr/bin/env python3
"""Update formulae to the latest release of the project each one packages.

    scripts/update-formula.py [FORMULA ...]

FORMULA is the name of a file under Formula/ without the .rb suffix;
without arguments, every formula is updated. The project is the GitHub
repository the formula's urls download from. When its newest release has
a different version than the formula, the script replaces the tag in every
url, downloads each file and writes its checksum to the sha256 line that
follows. Every url must be a release download with the tag as /vX.Y.Z/,
all of them from the same repository and tag, and each must be followed by
its sha256 line.

Prints one line per updated formula, "NAME OLD -> NEW", and appends the
same lines as the multi-line output "updates" to $GITHUB_OUTPUT when that
is set. A formula that cannot be updated is reported on stderr and does
not stop the others; the script then exits with status 1.
"""

import argparse
import hashlib
import json
import logging
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path

FORMULA_DIR = Path(__file__).resolve().parent.parent / "Formula"
URL_LINE = re.compile(r'^(\s*url ")([^"]+)(")\s*$')
RELEASE_URL = re.compile(
    r"^https://github\.com/([^/]+/[^/]+)/releases/download/v(\d+\.\d+\.\d+)/"
)
SHA_LINE = re.compile(r'^(\s*sha256 ")([0-9a-f]{64})(")\s*$')

log = logging.getLogger("update-formula")


class FormulaError(Exception):
    """A formula that cannot be updated, with the reason as its message."""


@dataclass
class Update:
    name: str
    old: str
    new: str

    def __str__(self) -> str:
        return f"{self.name} {self.old} -> {self.new}"


def release_of(lines: list[str]) -> tuple[str, str]:
    """Return the repository and the version the formula's urls download."""
    found: set[tuple[str, str]] = set()
    for line in lines:
        if m := URL_LINE.match(line):
            release = RELEASE_URL.match(m.group(2))
            if not release:
                raise FormulaError(
                    "url is not a GitHub release download with a vX.Y.Z tag: "
                    f"{m.group(2)}"
                )
            found.add((release.group(1), release.group(2)))
    if len(found) != 1:
        names = ", ".join(f"{repo} v{version}" for repo, version in sorted(found))
        raise FormulaError(f"expected urls of one release, found: {names or 'none'}")
    return found.pop()


def latest_release(repo: str) -> str:
    """Return the tag of the newest release that is neither draft nor pre-release."""
    try:
        out = subprocess.run(
            [
                "gh",
                "release",
                "list",
                "-R",
                repo,
                "--exclude-drafts",
                "--exclude-pre-releases",
                "--limit",
                "1",
                "--json",
                "tagName",
            ],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
    except subprocess.CalledProcessError as e:
        raise FormulaError(
            f"cannot list the releases of {repo}: {e.stderr.strip()}"
        ) from e
    releases = json.loads(out)
    if not releases:
        raise FormulaError(f"{repo} has no release")
    return releases[0]["tagName"]


def sha256_of(url: str) -> str:
    log.info("fetching %s", url)
    digest = hashlib.sha256()
    try:
        with urllib.request.urlopen(url) as response:
            for chunk in iter(lambda: response.read(1 << 20), b""):
                digest.update(chunk)
    except urllib.error.HTTPError as e:
        if e.code == 404:
            raise FormulaError(
                f"the release has no file {url.rsplit('/', 1)[-1]}; "
                "change the url in the formula to one of its assets"
            ) from e
        raise FormulaError(f"cannot download {url}: {e}") from e
    except urllib.error.URLError as e:
        raise FormulaError(f"cannot download {url}: {e.reason}") from e
    return digest.hexdigest()


def rewrite(lines: list[str], old: str, new: str) -> list[str]:
    """Return the lines with each url set to the new tag and its checksum renewed."""
    result = []
    pending_url = None
    for line in lines:
        if m := URL_LINE.match(line):
            pending_url = m.group(2).replace(f"v{old}", f"v{new}")
            line = f"{m.group(1)}{pending_url}{m.group(3)}\n"
        elif m := SHA_LINE.match(line):
            if pending_url is None:
                raise FormulaError("sha256 line without a url before it")
            line = f"{m.group(1)}{sha256_of(pending_url)}{m.group(3)}\n"
            pending_url = None
        result.append(line)
    if pending_url is not None:
        raise FormulaError("url line without a sha256 line after it")
    return result


def update(name: str) -> Update | None:
    """Update one formula; return what changed, or None if it is up to date."""
    path = FORMULA_DIR / f"{name}.rb"
    if not path.is_file():
        raise FormulaError(f"no such formula, expected {path}")
    lines = path.read_text().splitlines(keepends=True)
    repo, old = release_of(lines)
    new = latest_release(repo).removeprefix("v")
    if new == old:
        log.info("%s: %s is the latest release", name, old)
        return None
    path.write_text("".join(rewrite(lines, old, new)))
    return Update(name, old, new)


def write_output(updates: list[Update]) -> None:
    output = os.environ.get("GITHUB_OUTPUT")
    if not output or not updates:
        return
    with Path(output).open("a") as f:
        f.write("updates<<UPDATES_END\n")
        f.writelines(f"{u}\n" for u in updates)
        f.write("UPDATES_END\n")


def main() -> int:
    logging.basicConfig(format="%(message)s", level=logging.INFO)
    parser = argparse.ArgumentParser(
        description="Update formulae to the latest release of their project."
    )
    parser.add_argument(
        "formulae",
        nargs="*",
        metavar="FORMULA",
        help="name of a formula in Formula/; all of them if none is given",
    )
    args = parser.parse_args()
    names = args.formulae or sorted(p.stem for p in FORMULA_DIR.glob("*.rb"))

    updates: list[Update] = []
    failed: list[str] = []
    for name in names:
        try:
            result = update(name)
        except FormulaError as e:
            log.error("%s: %s", name, e)
            failed.append(name)
            continue
        if result:
            print(result)
            updates.append(result)

    write_output(updates)
    if failed:
        log.error("not updated: %s", ", ".join(failed))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
