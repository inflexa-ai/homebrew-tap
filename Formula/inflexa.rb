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
  version "0.9.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.0/inflexa-darwin-arm64"
      sha256 "7c00299cc28dbd20d58c0e7db5da5ce1ff35630e5bb956aa107de40a4e5d6951"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.0/inflexa-darwin-x64"
      sha256 "c9f33be8c9dc7677389dbf8d332801d5870abb292655ee47db1618d1d8800f1d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.0/inflexa-linux-arm64"
      sha256 "877c7d109f9ca5c14fddb6ec77509b5f05e1d64cb82f7e347b4b6c53f41cfe48"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.0/inflexa-linux-x64"
      sha256 "d1913a8ffdab62e040d40931e11a54f4c4816fb1767fbf402af75542e4223baa"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.0/THIRD-PARTY-NOTICES.txt"
    sha256 "fe2b1260d61f863e9db5b3c1546ec419e129dcb14bde06de2604a9836f71af40"
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
