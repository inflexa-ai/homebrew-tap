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
  version "0.3.3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.3/inflexa-darwin-arm64"
      sha256 "aab3276372494cda5d2b1c03eca862650aee25a9661897bd97fc67fb04e7a86a"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.3/inflexa-darwin-x64"
      sha256 "d0eccc59e92e919aea7b3ce7ac8c3fd4b45eb110794c8d85b20640da90b01b02"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.3/inflexa-linux-arm64"
      sha256 "cf0ed4372070326edbc718d9fde05c910a12c6744a16e93767fd7564d1eb048e"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.3/inflexa-linux-x64"
      sha256 "52bb7b667c7c6b956df8ff4dd199ea07a22219146219c068707cb10df7026616"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.3/THIRD-PARTY-NOTICES.txt"
    sha256 "21d1f953f1c4ce1089cd43e9e8320ded340b2ea77281a309582c91360a38ea12"
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
