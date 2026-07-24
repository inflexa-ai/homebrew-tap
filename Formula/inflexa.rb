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
  version "0.7.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.7.0/inflexa-darwin-arm64"
      sha256 "bb29bc958cedde06978ac36ca8e31161ca1bc26c746518849b955801dec59a17"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.7.0/inflexa-darwin-x64"
      sha256 "4042f5681b4c2549092ab94de9dd077a18a8f7c403f4da3236435e22bc6e5c87"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.7.0/inflexa-linux-arm64"
      sha256 "86df1c56fee3523e77a72bb5305027e4bb007df431526844b66118aa83af28ef"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.7.0/inflexa-linux-x64"
      sha256 "5843b1204493657cfbeb04072c2e7b8dc6eb22cdf56ed5b5db4fb3ef00a83351"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.7.0/THIRD-PARTY-NOTICES.txt"
    sha256 "26c9f7c3abc41858239d35e46719b554c1f5376ec4db84a0210f3dbbfe59aeb7"
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
