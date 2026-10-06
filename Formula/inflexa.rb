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
  version "0.24.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.0/inflexa-darwin-arm64"
      sha256 "3384e6304159c0c2eba60acf1244929cc2a71e3f473256dd8a2617dfe5fab698"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.0/inflexa-darwin-x64"
      sha256 "7f20091140e5a8082431a0954a9a78b13d4c814f71aef6edc8040e5dbba87952"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.0/inflexa-linux-arm64"
      sha256 "b443f5907dd7c796161587a02c893adc981e1a358e2861e272d35d2e5c0d3f78"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.0/inflexa-linux-x64"
      sha256 "1e8dd8215eca6f37bff1d4e45a8f1fd83e7ca6b91ed9f20d17fb257bdb651a3e"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.0/THIRD-PARTY-NOTICES.txt"
    sha256 "4e051cf3c287ab7be92150209a935d2eba568d150c7f92bf6faa0f5f34f8e1c3"
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
