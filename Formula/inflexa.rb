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
  homepage "https://inflexa.ai"
  # Explicit rather than scanned from the URL: the asset basenames end in
  # arch tokens (arm64, x64) that Homebrew's version detection could latch
  # onto, and the pinned value keeps livecheck comparisons exact.
  version "0.26.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.1/inflexa-darwin-arm64"
      sha256 "e2c3bdd7504dbcde85606b5d29141555ac751e611c916a43f4a7504354d40d1e"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.1/inflexa-darwin-x64"
      sha256 "d314058d5926866863d14edd66ecf4cb545edf4dc7c6d2e5f7eeef3273798893"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.1/inflexa-linux-arm64"
      sha256 "828fd6a6d9d2702b32671a180e2c479c1a848d37861a9b7ed1cc386d047dba89"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.1/inflexa-linux-x64"
      sha256 "02f1afca33fcad309107ed9af892bfd64c9ded31d62a946a16d51b6d814e7adc"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.1/THIRD-PARTY-NOTICES.txt"
    sha256 "4338e12b0df5934234c9266c96e9fefabe0767d465296f84b26a7f421e95c4c9"
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
