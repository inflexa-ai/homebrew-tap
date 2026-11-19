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
  version "0.26.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.0/inflexa-darwin-arm64"
      sha256 "9de9161e13a89ae9dad43c7b5c1ef34803edd552da4007517ffe461c0ea7bac7"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.0/inflexa-darwin-x64"
      sha256 "e4edd84be716a336a12bf860ebe8623d44745e52a77e95c2153b9196959ec7d9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.0/inflexa-linux-arm64"
      sha256 "50b6ab275f80d5a073d39be5f008fdc0bb00ca2c9e032b1eff5a8eb1f69596f9"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.0/inflexa-linux-x64"
      sha256 "505043881d8eb7e06e07082f4db654052518c6006042a258e8b3fa87f4fa4596"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.26.0/THIRD-PARTY-NOTICES.txt"
    sha256 "4bb76c7247f0c44f726a82e96b14f0eaee682831747d1f6adf1c62e4ecc8b373"
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
