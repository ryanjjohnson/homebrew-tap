#!/bin/bash
# Regenerates Formula/rndr.rb for an rndr release: the latest one, or the tag given.
#
#   ./update.sh            latest release
#   ./update.sh v0.1.5     that release
#
# Needs gh (signed in, or GH_TOKEN set). A release is only adopted if every
# binary carries build provenance signed by rndr's own release workflow, so a
# file swapped into a release by hand never reaches the formula.
set -euo pipefail

repo=ryanjjohnson/rndr
workflow=${repo}/.github/workflows/release.yml
here=$(dirname "$0")
cd "${here}"

if [[ $# -gt 0 ]]
then
  tag=$1
else
  tag=$(gh release view --repo "${repo}" --json tagName --jq .tagName)
fi
if [[ ! "${tag}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
  echo "update.sh: not a release tag: ${tag}" >&2
  exit 1
fi

# Run with no tag (the scheduled case): nothing to do if the formula is already there.
if [[ $# -eq 0 ]] && grep -q "/download/${tag}/" Formula/rndr.rb 2>/dev/null
then
  echo "Formula/rndr.rb is already ${tag}"
  exit 0
fi

# The commit the tag points at: the provenance must name that same commit.
commit=$(gh api "repos/${repo}/commits/${tag}" --jq .sha)

tmp=$(mktemp -d)
trap 'rm -rf "${tmp}"' EXIT

for name in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64
do
  file=rndr-${name}
  gh release download "${tag}" --repo "${repo}" --dir "${tmp}" --pattern "${file}"
  gh attestation verify "${tmp}/${file}" --repo "${repo}" --signer-workflow "${workflow}" \
    --source-digest "${commit}" --deny-self-hosted-runners >/dev/null
  echo "${file}: provenance ok"
done

if command -v sha256sum >/dev/null 2>&1
then
  hasher=(sha256sum)
else
  hasher=(shasum -a 256)
fi
line=$("${hasher[@]}" "${tmp}/rndr-darwin-arm64")
sum_darwin_arm64=${line%% *}
line=$("${hasher[@]}" "${tmp}/rndr-darwin-amd64")
sum_darwin_amd64=${line%% *}
line=$("${hasher[@]}" "${tmp}/rndr-linux-arm64")
sum_linux_arm64=${line%% *}
line=$("${hasher[@]}" "${tmp}/rndr-linux-amd64")
sum_linux_amd64=${line%% *}

base=https://github.com/${repo}/releases/download/${tag}
cat >Formula/rndr.rb <<EOF
# Written by update.sh from the ${tag} release. Do not edit by hand.
class Rndr < Formula
  desc "ASCII previewer for STL, OBJ and 3MF models in the terminal"
  homepage "https://github.com/${repo}"
  license "MIT"

  on_macos do
    on_arm do
      url "${base}/rndr-darwin-arm64"
      sha256 "${sum_darwin_arm64}"
    end
    on_intel do
      url "${base}/rndr-darwin-amd64"
      sha256 "${sum_darwin_amd64}"
    end
  end

  on_linux do
    on_arm do
      url "${base}/rndr-linux-arm64"
      sha256 "${sum_linux_arm64}"
    end
    on_intel do
      url "${base}/rndr-linux-amd64"
      sha256 "${sum_linux_amd64}"
    end
  end

  def install
    bin.install Dir["rndr-*"].first => "rndr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rndr --version")
    (testpath/"tri.obj").write "v 0 0 0\nv 1 0 0\nv 0 1 0\nf 1 2 3\n"
    assert_match "#", shell_output("#{bin}/rndr #{testpath}/tri.obj 25 -30 0 -s 40x12")
    assert_match "#", pipe_output("#{bin}/rndr 25 -30 0 -s 40x12", (testpath/"tri.obj").read)
  end
end
EOF
echo "Formula/rndr.rb is now ${tag}"
