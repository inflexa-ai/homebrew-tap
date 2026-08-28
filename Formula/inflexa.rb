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
  version "0.18.4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.4/inflexa-darwin-arm64"
      sha256 "4d6b7342ed9eb11f323690395bdc3c0b685a86a59ce46b8a722a6cc26908eb7f"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.4/inflexa-darwin-x64"
      sha256 "ed8ca379c75d9a268f81f0a1dbf85c41fa806b1222c95ff11bb01489536e225f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.4/inflexa-linux-arm64"
      sha256 "9d2cb476c218cb5a0c34c573c243f5e0a869a98304e8a940dc0d0bb3a469c391"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.4/inflexa-linux-x64"
      sha256 "fc3bca200ecba88b8180c05337327cc6bf9e399891ae686e3661e4294daf35fe"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.4/THIRD-PARTY-NOTICES.txt"
    sha256 "9ea4dc75546badc4268cc5dcf031a3112717d5b149c5a361518627e27089546e"
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
