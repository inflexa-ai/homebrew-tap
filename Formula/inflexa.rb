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
  version "0.5.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.5.0/inflexa-darwin-arm64"
      sha256 "dca4c6245d682b692225a50ea43ed966edf0ac46da422054e60fe2946ac11db7"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.5.0/inflexa-darwin-x64"
      sha256 "c47668c06fc13c0cf2f8554750c78bbf3ee22f4a9e19a52825c0f514d30b213b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.5.0/inflexa-linux-arm64"
      sha256 "3efb3c2a278861887cacd5f447019527c4258fa9f5adf58da1444f418e3e2383"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.5.0/inflexa-linux-x64"
      sha256 "b8e2500c312e62329cc254963e06a6258719d0b9fef9798a26caab85184ad1ce"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.5.0/THIRD-PARTY-NOTICES.txt"
    sha256 "4663643f047986ce9715dac936b693f5423326acc20d171a47c78e4ec6ce90c7"
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
