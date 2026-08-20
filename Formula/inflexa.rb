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
  version "0.17.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.0/inflexa-darwin-arm64"
      sha256 "c066a7cb30a6bd4b4acb27b928e37a2da6fa68e1cb1b6c6c581c7e220c4657a1"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.0/inflexa-darwin-x64"
      sha256 "bf92132e3b9194038c5be1261b3cce4265a7b701ff5bbcadfd99a2d8c13ef688"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.0/inflexa-linux-arm64"
      sha256 "c4c940b31441137a0ca2c732317f0244dff8163ec5fc930869c8d603b99b2976"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.0/inflexa-linux-x64"
      sha256 "e99d93f5d0947776db41001fe15acf8062430bebc73dc1c5c3c6659f5eacb9e2"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.17.0/THIRD-PARTY-NOTICES.txt"
    sha256 "f3632283df419b17c198f2c9815c657a4b37dbb49f7f4d0f280f810bb22deb60"
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
