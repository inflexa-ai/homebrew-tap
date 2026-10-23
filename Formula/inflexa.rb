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
  version "0.24.2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.2/inflexa-darwin-arm64"
      sha256 "845e2128443a06143b48dcea24aead8881ecc7f533affb6814c074b275be2ccf"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.2/inflexa-darwin-x64"
      sha256 "1beb14a1b43f973876409dbc560d312404ed46c94e9b6c56da609489f48f7ba4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.2/inflexa-linux-arm64"
      sha256 "ea3b5e26b172f1789389304e4708f54bd60cf74c2d83397a3efc1955c740c549"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.2/inflexa-linux-x64"
      sha256 "9416bc21ade5636fd39677bd6a54f28789442a9414d7c6583692b03bf8b6f930"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.24.2/THIRD-PARTY-NOTICES.txt"
    sha256 "735ba527e75263700fb9b703e0d81d449c359ad046421efd41c4148e5a347b8d"
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
