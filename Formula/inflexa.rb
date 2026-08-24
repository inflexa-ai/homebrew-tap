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
  version "0.17.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.1/inflexa-darwin-arm64"
      sha256 "2a430e06463c9eda51a5930ac9eefebcd2f6d33aa7f643f132b938b0b8d98c0a"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.1/inflexa-darwin-x64"
      sha256 "20e6b5b16b937ee2a98dc54182adf57ed5f2c526758f1eb2dbc8b3436a12cafe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.1/inflexa-linux-arm64"
      sha256 "e2de1451056599f1235a6cf583fe36a177c9687783eca694aa7ac4c1aa18d021"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.1/inflexa-linux-x64"
      sha256 "70d1ddde5f8da49954b5d9a598fd779d0238a3905689cee5698d449496dd9a9b"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.1/THIRD-PARTY-NOTICES.txt"
    sha256 "5713f2f64deaa269b8c586ef5e73217e8e9059cd62e9f98eeebeab3e6dae516a"
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
