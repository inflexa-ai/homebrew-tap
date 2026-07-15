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
  version "0.2.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.2.0/inflexa-darwin-arm64"
      sha256 "7b193e1ad49b4ea3d81df161cce4b1182d94dd5c0c1fbec4a20c6b7b79fee80f"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.2.0/inflexa-darwin-x64"
      sha256 "bf730635014eecff02898a4b84fba84736f13f333de713cb6c81bd95c98e9b05"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.2.0/inflexa-linux-arm64"
      sha256 "7c789ea97547de079d8d71052adcf3484d8ca1f012d3e169f14e7a06adc2d28b"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.2.0/inflexa-linux-x64"
      sha256 "b5d87f7c7b0f4574401073aa53881a2bc8c77dde453c31290d04ad819c47a0ff"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.2.0/THIRD-PARTY-NOTICES.txt"
    sha256 "454c2c8c59d7bf6c8be2081b37080b1d34ae44bc9926811e843bfb94ad796f73"
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
