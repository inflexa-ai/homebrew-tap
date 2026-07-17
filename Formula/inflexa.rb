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
  version "0.3.4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.4/inflexa-darwin-arm64"
      sha256 "3c1b2d8ad4df18199b23df1f85da3662eafc6137c7f38f6ed7f0dc52ba07123e"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.4/inflexa-darwin-x64"
      sha256 "f57597ae992421c9bfda181d68a3ae44c5072f2354d9537007263c23131b8cc7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.4/inflexa-linux-arm64"
      sha256 "ee957ba464406cd7bcf2d43ee82fd7b020f25f30f372946b7f156f4bbbcbfdce"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.4/inflexa-linux-x64"
      sha256 "0d20ccd7a61527e7cf941fe1fe654bc58f83295b86a4156c25611a4b22bda421"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.4/THIRD-PARTY-NOTICES.txt"
    sha256 "f58de87d779c857e0fb5715fc98c8f94c0f57e970c69ed1c768541a10e1d6a8e"
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
