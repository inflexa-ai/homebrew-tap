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
  version "0.21.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.1/inflexa-darwin-arm64"
      sha256 "1e97aca5e80de53d70fe6372007b0ec9fe6e7641e1e57beca196a8249f8f60cc"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.1/inflexa-darwin-x64"
      sha256 "9273ee2726c1a62c558df4cfb13f846bc0e3d360327cc39c8faab4cc17690180"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.1/inflexa-linux-arm64"
      sha256 "006fd0278d47d167884d2a55851870066e0010dbab031346a914dd14cc978b71"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.1/inflexa-linux-x64"
      sha256 "8197a3262798828534f8573d09d61a7d06bd9961efa1cb275791427c9f57669f"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.1/THIRD-PARTY-NOTICES.txt"
    sha256 "2e881ec7049078a30ef8706d1418d6730b969bebafe304081687237019e3adb1"
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
