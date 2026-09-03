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
  version "0.21.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.0/inflexa-darwin-arm64"
      sha256 "3cd99af282643647b6c2b3476133ee0a3e9bb8c42127bc16b83a8f507127e6a0"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.0/inflexa-darwin-x64"
      sha256 "057235e0c069e980b0cf77b23cb899cc9cf461d2842d208e54360d9120bcc69f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.0/inflexa-linux-arm64"
      sha256 "53d93aea2f1d53bef8f7d3199692d8941895f9ee46ef09ff10f4195bad9e8ccd"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.0/inflexa-linux-x64"
      sha256 "4ac66a660c415df30f68893b31b5c15ab651636187760407b407d4d66d2831b5"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.0/THIRD-PARTY-NOTICES.txt"
    sha256 "e2bbe92b211e8e8f9b384e6fe2d4dab740c50a1375f52d83b7bade55b3fc915a"
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
