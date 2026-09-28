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
  version "0.23.3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.3/inflexa-darwin-arm64"
      sha256 "a40a009df940f854ee9b35feeb7debfd73411f58f635975d0316c0f261f4e645"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.3/inflexa-darwin-x64"
      sha256 "90668d4bbd010e37aab6207549be6ad578806fac6345fb90df8c22d7b500fde9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.3/inflexa-linux-arm64"
      sha256 "4d9edf8181979fcdf9465585b7449f7cab55f9022d1082a564b0af8b0cdda429"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.3/inflexa-linux-x64"
      sha256 "ae5b9a48c11112e60f76ffe8ba789ae9d777c69a8b7695d653e6972263d32d8c"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.23.3/THIRD-PARTY-NOTICES.txt"
    sha256 "f5fd08e96acb71be9acd0cdc17199cfabeb393e4ce1a87d29f58f8b4e5fcb670"
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
