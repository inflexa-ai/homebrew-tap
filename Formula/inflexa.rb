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
  version "0.22.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.22.0/inflexa-darwin-arm64"
      sha256 "78643f12a23f0013dabb495b584fea1c2418de816c3bdf5b42da1d48bee1a634"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.22.0/inflexa-darwin-x64"
      sha256 "a7f15c0c1b39841e2d4184c321a6c7c1b3d2623e1fdb5c4e91959f8c962cd450"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.22.0/inflexa-linux-arm64"
      sha256 "faf366c4168cb540e9199396ca9af554c9e98ed16928d0fde7c8eab4553b0a73"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.22.0/inflexa-linux-x64"
      sha256 "5c51414eeda37428b9acc44a7d70438386a8d53aeffa4bf78af0a6c9beba6f28"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.22.0/THIRD-PARTY-NOTICES.txt"
    sha256 "2d0928b127a376574f484fa0cb3b8c46bcde7731d3eecf2c46c116f822229da1"
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
