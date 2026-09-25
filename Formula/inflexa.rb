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
  version "0.23.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.1/inflexa-darwin-arm64"
      sha256 "668386e42953ffa716c77de8f5e0d29647a478c102016d30f53ed3c922025e4f"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.1/inflexa-darwin-x64"
      sha256 "2aa1b7c9d03a31edcd9423f8b4dd21a5cf9356599377ace51695882d6f86c5a7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.1/inflexa-linux-arm64"
      sha256 "1aa15b0c12e4cee103125dab66c2399f7e1b5dcd9c8f286dab478dcaf47d7147"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.1/inflexa-linux-x64"
      sha256 "eac90281a46f8e459a42737549d3f8287fa4032d6ce41960cd85717ab3d8d3f8"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.1/THIRD-PARTY-NOTICES.txt"
    sha256 "f27936e1d4f5c90e0f504c2ab9fc31951546f9bf719eacd927750a7f7e53e0f3"
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
