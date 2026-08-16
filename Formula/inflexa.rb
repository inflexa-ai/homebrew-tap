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
  version "0.13.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.0/inflexa-darwin-arm64"
      sha256 "2f0b9bd91d463a595ca5782174c30e55cbb6cc774c4110055a2645b46920e239"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.0/inflexa-darwin-x64"
      sha256 "2c07012508c14fe98a28c344cb3a4fc1ebf1ff55a4247cb7ab0ea16a0d1c6ef3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.0/inflexa-linux-arm64"
      sha256 "186eae4e9082626b7064bd62b65f87013f21982484c69edc2a4ec4ba8ef8a343"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.0/inflexa-linux-x64"
      sha256 "0dfbedded4cd4e70b0b8d79e83bd4fcd9dd699efe8a551708863395fd733877d"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.0/THIRD-PARTY-NOTICES.txt"
    sha256 "6137965aa35c4efeccd38d7f387c4196bd899c38cd51b36f6d2019692ee43fe3"
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
