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
  version "0.23.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.0/inflexa-darwin-arm64"
      sha256 "b86f10d89ec51928c7573fbc9c260c2c55db962af3c9e73786f590b24e001d91"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.0/inflexa-darwin-x64"
      sha256 "59d0071ad70f864a5aaa910438a84ca34ef6b3d1165c50a91efd956c237d6308"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.0/inflexa-linux-arm64"
      sha256 "96d74641fd75209f047d64790281bf5a0ad1d4d3a9a39a4829a2cee5441de51e"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.0/inflexa-linux-x64"
      sha256 "125800bf83ab4c8418d49f891162a7c782f908e1b124bd30c71ab347c8a41b40"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.0/THIRD-PARTY-NOTICES.txt"
    sha256 "f27936e1d4f5c90e0f504c2ab9fc31951546f9bf719eacd927750a7f7e53e0f3"
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
