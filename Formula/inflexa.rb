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
  version "0.23.4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.4/inflexa-darwin-arm64"
      sha256 "5d79979bf4b49a3d28f56fb0b234e40859d60152c03b2e1fc85b8b08e7bacfc4"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.4/inflexa-darwin-x64"
      sha256 "f33d1eee118f2c7e3f8ac67fbed259a3ca2f36b7db3e10fabbeb8bbaea8b6d8c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.4/inflexa-linux-arm64"
      sha256 "0a7b3c29a48b288c0c7b366b7ade28cb5f1651da88a40254f9dc3616740d8a58"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.4/inflexa-linux-x64"
      sha256 "05e93b7c79e7eb8ea268d3007f6a405b6a80a9157b6e95e7a66969b89911d309"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.4/THIRD-PARTY-NOTICES.txt"
    sha256 "a05677a2d735794e578bb5d72f1b1aa19dc2f42f4283edeff0b12b4ee5134586"
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
