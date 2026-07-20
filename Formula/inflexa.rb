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
  version "0.4.2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.2/inflexa-darwin-arm64"
      sha256 "9d801f91bce869882c1e5fb4b38c1515d78f8cc38d2264b8a39662d89e1b13b8"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.2/inflexa-darwin-x64"
      sha256 "51f32ed572b3ed8722ce8675fb02c9909f3b59ec4e29847b9be56a3143b95ed0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.2/inflexa-linux-arm64"
      sha256 "6879a398ac17a42a118d76d3e54e07654548aec211640a46b6d168cea672f8b4"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.2/inflexa-linux-x64"
      sha256 "b7da7bee94b75ab71701e518853e37149acac96adee395b645323eedf6503a2f"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.2/THIRD-PARTY-NOTICES.txt"
    sha256 "6e96f5900fbf465291c2dcb02b44498cdcc6ebf5b3cbfec3192dbaab5c31884f"
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
