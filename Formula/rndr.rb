# Written by update.sh from the v0.1.5 release. Do not edit by hand.
class Rndr < Formula
  desc "ASCII previewer for STL, OBJ and 3MF models in the terminal"
  homepage "https://github.com/ryanjjohnson/rndr"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.5/rndr-darwin-arm64"
      sha256 "cef279eb4ae0af7fee6561a97e7359caf70c989de1fcef1e704fd5a3ac15e76e"
    end
    on_intel do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.5/rndr-darwin-amd64"
      sha256 "c77a86b3a4d8b89ab90c5373d8cc261d9a5f4aab589bd6b22daf57cdd07389c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.5/rndr-linux-arm64"
      sha256 "f1598a36a4d7dec4d1daf0c6c60cf5341df41c063a1b390035278ec6b63a0438"
    end
    on_intel do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.5/rndr-linux-amd64"
      sha256 "71dc9af43ea841afd64e6b239f1cdacea9babf465fa88cb33ca6bd456793addf"
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
