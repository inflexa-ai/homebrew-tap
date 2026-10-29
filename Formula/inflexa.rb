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
  version "0.25.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.0/inflexa-darwin-arm64"
      sha256 "a5ea5c606ce2e89d940cf0b0014e9dbe6c4ef05576a1def4b39d45d3df9bd5c8"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.0/inflexa-darwin-x64"
      sha256 "2b22e70e5067e583fcd5200f7a10f665d20f743c60cc347a897fd8a8960d96ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.0/inflexa-linux-arm64"
      sha256 "3f7d0360f42d201c58cb4f39fea7542621f14de78f150a7a08ea046d43a1bc07"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.0/inflexa-linux-x64"
      sha256 "29e2b09d17007435ae2e1de54c3b4e1d8a8851de625adca35703fea694373bc4"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.0/THIRD-PARTY-NOTICES.txt"
    sha256 "db95067f898ecaa1c9a80258b4692e7e0130262e5b96a71bc05468c931d3e156"
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
