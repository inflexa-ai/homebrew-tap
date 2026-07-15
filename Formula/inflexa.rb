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
  version "0.3.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.0/inflexa-darwin-arm64"
      sha256 "3ab146a960d390564e235c8ee74ac4cce0a01f3d4516f7e120cc2301274f9f9e"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.0/inflexa-darwin-x64"
      sha256 "a24ff38f0680dadc6be797df2ef95a6e0058c7f7bd3da984846d51338bcde12e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.0/inflexa-linux-arm64"
      sha256 "26edc267ff6ba398cedaa5bf783ab4792d57b273e5eefd9cc529ac6652498771"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.0/inflexa-linux-x64"
      sha256 "2b411af6c03fba9203f64767a254a6693a013b794b5cc5388cd5f8cec4d82d2f"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.0/THIRD-PARTY-NOTICES.txt"
    sha256 "6666d2e3da773f24cdb65cb8e2a53406549f490e91fc651abd3ecb0ded73bf6e"
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
