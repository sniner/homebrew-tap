#!/usr/bin/env python3
"""Bring a formula to the latest release of the project it packages.

    scripts/update-formula.py FORMULA OWNER/REPO

FORMULA is the name of a file under Formula/ without the .rb suffix. The
script asks GitHub for the newest release of OWNER/REPO, and when the
formula says an older version, it rewrites every url line to the new
tag, downloads each archive and puts its checksum on the sha256 line
that follows. Every url line must carry the version as vX.Y.Z, all of
them the same one, and the next sha256 line must belong to it.

Prints one line per formula it changed, in the form "NAME OLD -> NEW",
and appends the same as summary= to $GITHUB_OUTPUT when that is set.
A formula already at the latest release is left alone, silently.
"""

import hashlib
import json
import os
import re
import subprocess
import sys
import urllib.request

URL_LINE = re.compile(r'^(\s*url ")([^"]+)(")\s*$')
URL_VERSION = re.compile(r"/v(\d+\.\d+\.\d+)/")
SHA_LINE = re.compile(r'^(\s*sha256 ")([0-9a-f]{64})(")\s*$')


def latest_release(repo):
    out = subprocess.run(
        ["gh", "release", "list", "-R", repo, "--exclude-drafts",
         "--exclude-pre-releases", "--limit", "1", "--json", "tagName"],
        check=True, capture_output=True, text=True).stdout
    releases = json.loads(out)
    if not releases:
        sys.exit(f"{repo}: no release found")
    return releases[0]["tagName"]


def sha256_of(url):
    digest = hashlib.sha256()
    with urllib.request.urlopen(url) as response:
        for chunk in iter(lambda: response.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    name, repo = sys.argv[1], sys.argv[2]
    path = f"Formula/{name}.rb"
    with open(path) as f:
        lines = f.read().splitlines(keepends=True)

    versions = set()
    for line in lines:
        if m := URL_LINE.match(line):
            found = URL_VERSION.search(m.group(2))
            if not found:
                sys.exit(f"{path}: url without /vX.Y.Z/: {m.group(2)}")
            versions.add(found.group(1))
    if len(versions) != 1:
        sys.exit(f"{path}: expected one version in the urls, found {sorted(versions)}")
    old = versions.pop()

    tag = latest_release(repo)
    new = tag.removeprefix("v")
    if new == old:
        return

    pending_url = None
    for i, line in enumerate(lines):
        if m := URL_LINE.match(line):
            pending_url = m.group(2).replace(f"v{old}", f"v{new}")
            lines[i] = f"{m.group(1)}{pending_url}{m.group(3)}\n"
        elif m := SHA_LINE.match(line):
            if pending_url is None:
                sys.exit(f"{path}: sha256 line without a url before it")
            print(f"fetching {pending_url}", file=sys.stderr)
            lines[i] = f"{m.group(1)}{sha256_of(pending_url)}{m.group(3)}\n"
            pending_url = None
    if pending_url is not None:
        sys.exit(f"{path}: url line without a sha256 line after it")

    with open(path, "w") as f:
        f.writelines(lines)

    summary = f"{name} {old} -> {new}"
    print(summary)
    if output := os.environ.get("GITHUB_OUTPUT"):
        with open(output, "a") as f:
            f.write(f"summary={summary}\n")


if __name__ == "__main__":
    main()
