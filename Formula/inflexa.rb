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
  version "0.3.5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.5/inflexa-darwin-arm64"
      sha256 "6f2ad5a5dc345a1a389acb21265bd58bf08656e817b8bf0f7bb22a8f020c7892"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.5/inflexa-darwin-x64"
      sha256 "01ae43d3ab5a3f4676e5cbe9d24f3a6dc29bd17f7539e311f5a74d344af38976"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.5/inflexa-linux-arm64"
      sha256 "ab0c99304c0ead7b0d53790792a111528be505ead256208180c0e2824a1d40f9"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.5/inflexa-linux-x64"
      sha256 "a8031ae343f6d2eb25c811ffc6d87141b3c270a0af3ce508d5dceec9a5011836"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.3.5/THIRD-PARTY-NOTICES.txt"
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
