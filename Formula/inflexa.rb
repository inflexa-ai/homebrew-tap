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
  version "0.3.6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.6/inflexa-darwin-arm64"
      sha256 "082c805487c24f03586380c150bfe92320bc2119d1dd6752d6a9a8e8b4663e5a"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.6/inflexa-darwin-x64"
      sha256 "ff7c4d28577cda74434e159b21510aeb7decc90973599abe39879ae71a95f194"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.6/inflexa-linux-arm64"
      sha256 "9e468bf4d7e7215f1f1b41efe36dc14358c9761723816ec91e1034916172c13e"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.6/inflexa-linux-x64"
      sha256 "b089947097637a46acaa126f3f36099ec23adc7dabe7b29c8f30e56caf628d51"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.6/THIRD-PARTY-NOTICES.txt"
    sha256 "ee34b7a164c510bd0e0c072c376fd91ff9fa8cf54bd5bde8749dc308cff479a3"
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
