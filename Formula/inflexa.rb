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
  version "0.3.2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.2/inflexa-darwin-arm64"
      sha256 "3704090f82f6ebd2486d7b9f6e53bd80c9cf4baf4f3c647c19e7eebab71bf7e9"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.2/inflexa-darwin-x64"
      sha256 "5048beb34a58128679a09957744e2c74b48fda81ac296c83e14614fb721851b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.2/inflexa-linux-arm64"
      sha256 "88db7403a22ddbb5dc44b10c35c1c48e30bb4a50ab8b0e86b4b6e4365567f3b1"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.2/inflexa-linux-x64"
      sha256 "9a35707d76591a122d14120dadf71f610b6f4d3c9333c220eaad30157303c0c9"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.2/THIRD-PARTY-NOTICES.txt"
    sha256 "21a06739bf78a1a15995a126f4f4fa054e1199eae9ad96206d9dad60cb7aa0cf"
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
