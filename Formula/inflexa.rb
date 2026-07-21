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
  version "0.4.4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.4/inflexa-darwin-arm64"
      sha256 "f3e47637bbe280020c876bfcf4e8d35d5cfd9f5f473abe01562110c731b4f5e0"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.4/inflexa-darwin-x64"
      sha256 "72f28f512a06784645a1c9d4fd7bfea65c2784dd2641859f6a460171481f62f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.4/inflexa-linux-arm64"
      sha256 "b9e2faae5da6f747291e01bee9c4dcb31527711e563f70a2a143384c173749dd"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.4/inflexa-linux-x64"
      sha256 "6009caae0f9f8d5b6df51299165a15bbd56ff48511f089af0060b4848bd188ec"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.4/THIRD-PARTY-NOTICES.txt"
    sha256 "959f14c7feec898b7db40eaa5b88e36e1c4c863b9dea16a157361e04279f9a5d"
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
