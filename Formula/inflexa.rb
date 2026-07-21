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
  version "0.4.3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.3/inflexa-darwin-arm64"
      sha256 "fad74896ee1cff27771a8a4a9d88813ed59ff355346f77de6e980d644056147c"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.3/inflexa-darwin-x64"
      sha256 "a2d74170e01da565a01e8affbc3d04a828b6e3b8baa651a472722527f0d6f7df"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.3/inflexa-linux-arm64"
      sha256 "910b27443c8147455aaef2ae04054ecfda49b4d505362a8a7686161b4d9a056c"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.3/inflexa-linux-x64"
      sha256 "76596b20dc8ac2c01170622a2524600122973b12485bb197df27c550d9e986da"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.3/THIRD-PARTY-NOTICES.txt"
    sha256 "924a268971ec93ad00b68c9268716b9a7a5096c8ba2a1a442a36aab1c9fe368f"
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
