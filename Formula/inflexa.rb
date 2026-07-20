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
  version "0.4.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.1/inflexa-darwin-arm64"
      sha256 "189e6205bf8819786a521b9ef2f5b9ed1ee5773c0e8e27aae7d6a4e4c6c6b9c1"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.1/inflexa-darwin-x64"
      sha256 "d0348e7be5f436ff35fbebbc11d7c31e60b88b43fa4cd1aca8ee3c0b77d0d36d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.1/inflexa-linux-arm64"
      sha256 "277a38530c2bfa86fa35ff82f25f646f090f18a9456543f5f0f258ebad875ed8"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.1/inflexa-linux-x64"
      sha256 "258135c66c87f22f8c6bcce6342003f075dfd6a2a18a1c9ada3f57b6b3d3ea92"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.1/THIRD-PARTY-NOTICES.txt"
    sha256 "bbdd7902f4544c2273afe1accb992ec5eee299e95d396f1204a8a20bbe667108"
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
