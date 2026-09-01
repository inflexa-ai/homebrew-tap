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
  version "0.20.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.20.0/inflexa-darwin-arm64"
      sha256 "d2566a20a7a8d01364eebe5213a5b53f1e9c27090842edd540a90fffbcc57c23"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.20.0/inflexa-darwin-x64"
      sha256 "ae87293f57f960b11ff513dee9101b8384465b0477d18a30f1a47cb86f3e603d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.20.0/inflexa-linux-arm64"
      sha256 "7c122a23af1fb115a900862a37f9f2a8ef9b1da8660c0bc324a26687aa37ef06"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.20.0/inflexa-linux-x64"
      sha256 "18a706542fe3a44b658ef71ab598db289b41e4fd57885aeb581fbe4391b10ff3"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.20.0/THIRD-PARTY-NOTICES.txt"
    sha256 "26ff7624a7f3e2cda7c4568e8ef8a7dc21b2d06512b26436ef510d41b92057cc"
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
