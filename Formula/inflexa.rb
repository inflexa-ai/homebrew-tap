# Source template for Formula/inflexa.rb in inflexa-ai/homebrew-tap — the tap
# copy is generated per release (rendered by render.sh, pushed by the
# homebrew.yml workflow) and must never be edited there by hand.
#
# The formula installs the pre-built release binary rather than building from
# source: a Bun-compiled binary cannot meet homebrew-core's from-source rule
# (Bun itself is tap-only for the same reason), so a self-owned tap with a
# binary-download formula is the standard channel — same model as oven-sh/bun.
class Inflexa < Formula
  desc "Local-first AI agent for reproducible biological data analysis"
  homepage "https://github.com/inflexa-ai/inflexa"
  # Explicit rather than scanned from the URL: the asset basenames end in
  # arch tokens (arm64, x64) that Homebrew's version detection could latch
  # onto, and the pinned value keeps livecheck comparisons exact.
  version "0.10.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.0/inflexa-darwin-arm64"
      sha256 "cccc2b53b59143afcffcdccdd03dcc6b4271c65adc6c7ff3680fab94268e3758"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.0/inflexa-darwin-x64"
      sha256 "53fe7481c1205414f9adbde14b227e87f36e48dac346d6e0a487117efd09829c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.0/inflexa-linux-arm64"
      sha256 "4e38f2a06cad34ce2f8785962eaa6c9d987b7e3ac0b49b200a18d31ced4457be"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.0/inflexa-linux-x64"
      sha256 "0e742430e350693bf4deba14a33ab020050178d825e76b560d67f1355422e496"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.0/THIRD-PARTY-NOTICES.txt"
    sha256 "d10624835ec4ebe485a10e368635215462d5807d78ebf2b557057f15aa792fb3"
  end

  def install
    # The staged download is the bare per-platform asset (inflexa-darwin-arm64,
    # …); the glob resolves whichever platform's name this install staged.
    bin.install Dir["inflexa-*"].first => "inflexa"
    resource("third-party-notices").stage do
      doc.install "THIRD-PARTY-NOTICES.txt"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inflexa --version")
  end
end
