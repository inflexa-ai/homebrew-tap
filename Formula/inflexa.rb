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
  version "0.6.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.6.0/inflexa-darwin-arm64"
      sha256 "c8e97f5e2a11fb129d632773af8bf26624da3aa9a656a85966effc34501c6e95"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.6.0/inflexa-darwin-x64"
      sha256 "f6c3d68a0882370c69856bc79c0a26118e0651381d73e287d97aea382427cd6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.6.0/inflexa-linux-arm64"
      sha256 "af275a7c94a77deffa87d2d55495c0431c9206d5c62381f6aeca03b25725a2eb"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.6.0/inflexa-linux-x64"
      sha256 "0386586cefa5306b1aaa5720bc551851c71b34b3e064c4945168ffb825bf2f5c"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.6.0/THIRD-PARTY-NOTICES.txt"
    sha256 "e0519d3b645f77906a695659036506b999488591401a2d425315d6d8ca946243"
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
