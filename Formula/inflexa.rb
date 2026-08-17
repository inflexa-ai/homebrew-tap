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
  version "0.13.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.1/inflexa-darwin-arm64"
      sha256 "2c9f69be0a2801a463464cbfcaa0f3b2948e04c4e41a1a412b3dc275b4f684e9"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.1/inflexa-darwin-x64"
      sha256 "d9995b2f8329e886b3a7342e6f9402164d216189037bbf24ef8224471757aaa9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.1/inflexa-linux-arm64"
      sha256 "7c02e64b5df797ded8104c028572eb673677e7e5291a10a823d0fe45393bdf7f"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.1/inflexa-linux-x64"
      sha256 "f0815744123e5161c7f8f584cd38509ce411e5491622032038c22b5344519902"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.13.1/THIRD-PARTY-NOTICES.txt"
    sha256 "ad3b9bfc5e2ce49c098080ac50bd31e8eba43d6bc00c76e2b26988769e52cfe7"
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
