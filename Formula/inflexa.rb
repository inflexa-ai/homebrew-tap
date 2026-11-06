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
  version "0.25.2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.2/inflexa-darwin-arm64"
      sha256 "b6f591eba9b76a1e0348bf35530d1cdce63d1fdd24c19529460225dd45101cfd"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.2/inflexa-darwin-x64"
      sha256 "14b9ab3e843c4226d0cab31d8548a91419e9196ca7f9f754a99e801d6dc12626"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.2/inflexa-linux-arm64"
      sha256 "eba4dbd12ffabcbf02de409ba323ef78108cd37e415d23659a2dfb69ef0eac1a"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.2/inflexa-linux-x64"
      sha256 "92f4136c8e729dab273838847a8ff814f3687de3a573f8872ae70427f29076f0"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.2/THIRD-PARTY-NOTICES.txt"
    sha256 "5deabea1360f8f235d5d042b484ec7279cbf739404c2244ea6d3e34b114fddb3"
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
