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
  version "0.15.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.15.0/inflexa-darwin-arm64"
      sha256 "faaf94674114eb033c1ccc318be3eb8740e88cd9b72c4502cfab022442672c11"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.15.0/inflexa-darwin-x64"
      sha256 "354d3dffcc3f0c7d81534d7f5c802d0aea640ce7c94e6c0fcb2dc140f660aa66"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.15.0/inflexa-linux-arm64"
      sha256 "65668cfe8f145d233743449abaee9ff3839b44ec26c6f1cc067f22a9d327426c"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.15.0/inflexa-linux-x64"
      sha256 "dbe19d05209e17801ad0246a0188173a3c1e1d0dd6e36c6e93b933a6a4a65670"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.15.0/THIRD-PARTY-NOTICES.txt"
    sha256 "0c31f4edcae1a63d2b6331ae996e4f31379e3f0ca9dafd38fb94752b29253d12"
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
