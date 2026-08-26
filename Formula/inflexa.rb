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
  version "0.18.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.1/inflexa-darwin-arm64"
      sha256 "28ef8038307066c6ab2956d39455bc934dab0dea034dcdc04258eb4befa89917"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.1/inflexa-darwin-x64"
      sha256 "765a05feda7585d554ede7334b13c404f00038ecabe1d0ebe295290babacbc6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.1/inflexa-linux-arm64"
      sha256 "454e72c1c0fb113677a7f816b778b2e5039ddd623272e84d00d94894b368a892"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.1/inflexa-linux-x64"
      sha256 "aa4985858d43935ae74986a452280a6644c0cac9adf244dd048a50d87ff13660"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.1/THIRD-PARTY-NOTICES.txt"
    sha256 "0a0ead4331895e824411599f0f6856e3ae08b6e5306e5b5b00730efb8ba0f5a2"
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
