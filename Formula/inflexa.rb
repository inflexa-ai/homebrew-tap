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
  version "0.18.5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.5/inflexa-darwin-arm64"
      sha256 "d9d3a2f99526ecb520111229bb45025a0476f6495e80fd00c1dd20711681daf6"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.5/inflexa-darwin-x64"
      sha256 "6e89704a6978e7ac70edf53be7a673e663a7c475cc3adc7c1bc1b4770ef1b34c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.5/inflexa-linux-arm64"
      sha256 "09e1f87e7fa5d3df33c6a781a4d9e7c53c59b7685320abc267c85b9cdcf7b489"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.5/inflexa-linux-x64"
      sha256 "9d491fd2682d2cdb1bad19d5e3afcf326c7f81915e09ceeb301db1ea1be47a22"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.5/THIRD-PARTY-NOTICES.txt"
    sha256 "8ca0339d7d1b346449c2d28e0e7bd5b8250022492a893201395bdd49966a19d5"
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
