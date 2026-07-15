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
  version "0.3.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.1/inflexa-darwin-arm64"
      sha256 "7ee9ed0d5c5f5cd9f8c1db9a8e45ea869d60a893722b5c2c40c46c272d6129ff"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.1/inflexa-darwin-x64"
      sha256 "cdef5032b80115751fab48f432a0573059dcb85685859ab9b1625961ed224613"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.1/inflexa-linux-arm64"
      sha256 "17edfe8105e8c6e6831dff4c8f91135e9f1564d659145deaaf23fef4ff519512"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.1/inflexa-linux-x64"
      sha256 "6a9f2f4d0a3b03c7a74879d559f868004dd9bc962e05f25c1f0b57015cb118ee"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.1/THIRD-PARTY-NOTICES.txt"
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
