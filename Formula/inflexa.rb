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
  version "0.21.3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.3/inflexa-darwin-arm64"
      sha256 "ee9061b507c3cb44a179829c803f77daa2ccb7e1b38b7ac1583435bee8b58570"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.3/inflexa-darwin-x64"
      sha256 "f86e4eb7272ce4fc68f3ad08cbecffbdf51f0075317d1843bc2adde7a41874e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.3/inflexa-linux-arm64"
      sha256 "b69874501525047397e99cde30ce383bf543a91c1bf87c84ac05d25993f19f08"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.3/inflexa-linux-x64"
      sha256 "149d2e4cf1c214b7152d0aafdb4b234251740e0eaa6a9eaf0c902bbd15cebfff"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.3/THIRD-PARTY-NOTICES.txt"
    sha256 "75555ff4a254aa03eaea9ad7783f05130334b6fa37059601dc32100ca8f4482f"
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
