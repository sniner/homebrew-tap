# sniner/tap

Homebrew formulae for [sniner](https://github.com/sniner)'s tools.

```console
$ brew install sniner/tap/ossuary
```

That trusts the one formula it names. Homebrew 6 loads nothing from a
tap it was not told to trust, so installing by short name takes a
`brew trust` first, for the formula or for the whole tap:

```console
$ brew tap sniner/tap
$ brew trust sniner/tap
$ brew install ossuary
```

| Formula | Installs | Runs on | Project |
|---|---|---|---|
| `exhume` | `exhume` | macOS | [sniner/exhume](https://github.com/sniner/exhume) |
| `exorcise` | `exorcise` | macOS | [sniner/exorcise](https://github.com/sniner/exorcise) |
| `ossuary` | `ossuary`, `ossuary-mount`, `ossuary-mailvault`, `ossuary-fix` and the four extractors | macOS, Linux | [sniner/ossuary](https://github.com/sniner/ossuary) |
| `uwhat` | `uwhat` | macOS on Apple Silicon | [sniner/uwhat](https://github.com/sniner/uwhat) |

The formulae install the binaries a project's GitHub release carries,
no compiler needed. A workflow in this repository asks each project for
its newest release once a day and updates the formula, so a new version
arrives here within a day of its release; `workflow_dispatch` runs it
at once.
