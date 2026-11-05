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
  version "0.25.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.1/inflexa-darwin-arm64"
      sha256 "6136d1e19acbbb52153fe6878c51ae4d19228a33386a0d08fab0150de76db080"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.1/inflexa-darwin-x64"
      sha256 "f9c5aa997dfbd5754d2548a5ac0000f67e9738a71dca9d9b0731d1743bc04c20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.1/inflexa-linux-arm64"
      sha256 "e19b0d162d64a9a248d0de7f11c6f9148fb35c139333ff2525d1bfde83335459"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.1/inflexa-linux-x64"
      sha256 "29181e1c27068dbea7b8d1df9594c7be718788cdda5cfb9a5e3597b5e67e87a6"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.25.1/THIRD-PARTY-NOTICES.txt"
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
