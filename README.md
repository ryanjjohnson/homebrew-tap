# ryanjjohnson/tap

[![tests](https://github.com/ryanjjohnson/homebrew-tap/actions/workflows/tests.yml/badge.svg)](https://github.com/ryanjjohnson/homebrew-tap/actions/workflows/tests.yml)

A [Homebrew](https://brew.sh) tap for [rndr](https://github.com/ryanjjohnson/rndr), an ASCII
previewer for STL, OBJ and 3MF models in the terminal.

```sh
brew install ryanjjohnson/tap/rndr
```

Works on macOS (Apple silicon and Intel) and Linux (x86-64 and arm64). Later, `brew upgrade`
picks up new versions.

## What you get

The formula installs the same binary that is attached to the rndr release; nothing is built on
your machine. Homebrew checks the download against the SHA-256 in the formula.

The formula is never edited by hand. `update.sh` writes it, and only after checking that each
release binary carries build provenance signed by rndr's own release workflow for the commit the
release tag points at. A file swapped into a release by hand would fail that check and never
reach the formula. rndr's release workflow runs it as the last step of each release, using a
deploy key that can write to this repository and nothing else; the `tests` workflow then
installs and tests the formula on all four platforms. The `update` workflow here does the same
by hand.

To check a binary yourself:

```sh
gh attestation verify "$(brew --prefix)/bin/rndr" --repo ryanjjohnson/rndr
```

## Maintaining

```sh
./update.sh           # regenerate Formula/rndr.rb for the latest release
./update.sh v0.1.5    # or for a particular one
```
