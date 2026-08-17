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
  version "0.14.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.14.0/inflexa-darwin-arm64"
      sha256 "48f4d4d02312b31fcb0845b3a175b7dc95943e805cfefc0d02f62845b2fbedcf"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.14.0/inflexa-darwin-x64"
      sha256 "5bc37758081eb7671b71cbf478bdd47169e63d9347f374a39278496bb0d13e53"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.14.0/inflexa-linux-arm64"
      sha256 "02e440f943e0e24f6576e0b71dcaa6af991842b5cbcf2251d161e7063403b728"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.14.0/inflexa-linux-x64"
      sha256 "efecfa2cd78fedd5c0904c7bc91f5b9cf0d58ae474262216906e0e816a7bfe40"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.14.0/THIRD-PARTY-NOTICES.txt"
    sha256 "2ec95000598d6c8512c6c14df927e5790089427e24b20a53a3000a396ec85e0c"
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
