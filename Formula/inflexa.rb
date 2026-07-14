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
  version "0.1.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.1.0/inflexa-darwin-arm64"
      sha256 "bd48be6107dd4f5931677d7f2c18a6193379b6ce94de94c6b0b1efcb29ba0f4a"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.1.0/inflexa-darwin-x64"
      sha256 "ce4ec13e8ef43f3eabd57047bd95335d60f21af7645a8c06b0c653a84aa28c67"
    end
  end

  on_linux do
    # linux-arm64 is not in the release target matrix (cli/scripts/build.ts);
    # Homebrew fails with a clear unsupported-platform error there.
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.1.0/inflexa-linux-x64"
      sha256 "7abec28c1c04de185de37deeddf2fa7756cec9d4a56e7d26b427e315e6488db4"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.1.0/THIRD-PARTY-NOTICES.txt"
    sha256 "387a2c1784e4f0d16eb478e0750ca9e84027460fd86969f53d4e354b5ff40420"
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
