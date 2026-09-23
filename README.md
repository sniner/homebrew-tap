# sniner/tap

Homebrew formulae for [sniner](https://github.com/sniner)'s tools.

```console
$ brew install sniner/tap/ossuary
```

Or tap once and install by name:

```console
$ brew tap sniner/tap
$ brew install ossuary
```

| Formula | Installs | Project |
|---|---|---|
| `ossuary` | `ossuary`, `ossuary-mount`, `ossuary-mailvault`, `ossuary-fix` and the four extractors | [sniner/ossuary](https://github.com/sniner/ossuary) |

The formulae install the binaries a project's GitHub release carries,
no compiler needed. A workflow in this repository asks each project for
its newest release once a day and updates the formula, so a new version
arrives here within a day of its release; `workflow_dispatch` runs it
at once.
