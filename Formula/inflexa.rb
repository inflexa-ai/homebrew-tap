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
  version "0.21.6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.6/inflexa-darwin-arm64"
      sha256 "4b1f45469594100bfb823520e8ee5fd1338732ad6a99b34c52615ee0ad13d8d6"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.6/inflexa-darwin-x64"
      sha256 "57ed2fb978b87daedda95b2e0a1be7d28fd3c0421cc9d858fb504474a72af8b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.6/inflexa-linux-arm64"
      sha256 "6d14a447f056d03ee5326edca791e7a2addd7d972fa655f9328d9dd1eddd5c1d"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.6/inflexa-linux-x64"
      sha256 "a7db2ca1f161a929decf0a3cc4072ca1b7b6823a36490f8067cc79d38936b340"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.6/THIRD-PARTY-NOTICES.txt"
    sha256 "d310a6b8612d59002d5fedd855c4297de30c7114d16659350d2ae50ebb0c140a"
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
