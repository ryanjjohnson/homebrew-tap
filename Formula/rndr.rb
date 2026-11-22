# Written by update.sh from the v0.1.7 release. Do not edit by hand.
class Rndr < Formula
  desc "ASCII previewer for STL, OBJ and 3MF models in the terminal"
  homepage "https://github.com/ryanjjohnson/rndr"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.7/rndr-darwin-arm64"
      sha256 "5b14b84e1d2a7afd87f7e5be71a7616806942b9fd4e657aeda8da8f4acaf7a80"
    end
    on_intel do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.7/rndr-darwin-amd64"
      sha256 "403e5c08b80c102bd7bf495dee93d676b1ccfe27b870b1223b3354b01cb71ec0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.7/rndr-linux-arm64"
      sha256 "9bbf7b70b85b59c1a23baf103eb905a6ee969f0f0e7497f1f3a00912f59a6c1a"
    end
    on_intel do
      url "https://github.com/ryanjjohnson/rndr/releases/download/v0.1.7/rndr-linux-amd64"
      sha256 "4a4df6c8068fcb79012819eb87321ac1eadc3e9da549456e1df05c53ee02c119"
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
