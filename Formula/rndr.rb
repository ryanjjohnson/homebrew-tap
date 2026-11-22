# Written by update.sh from the v0.1.6 release. Do not edit by hand.
class Rndr < Formula
  desc "ASCII previewer for STL, OBJ and 3MF models in the terminal"
  homepage "https://github.com/ryanjjohnson/rndr"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.6/rndr-darwin-arm64"
      sha256 "6efa44aa073f20991c40ce9114706b98257416ce895a29477b6ee1dea4eac8d8"
    end
    on_intel do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.6/rndr-darwin-amd64"
      sha256 "d2be2e652f52d33113ab72e9fe794d580192137ea24779e1b2c3e6ed513dfdad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.6/rndr-linux-arm64"
      sha256 "b23ffb4d3685fcb4bea0ffed9cde98d9f99eaf8dc0805197aa24874ea6334f18"
    end
    on_intel do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.6/rndr-linux-amd64"
      sha256 "f534aea6644292454693c40d43e18e49a5f5b894584719d29264ecd7a8a8fb4c"
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
