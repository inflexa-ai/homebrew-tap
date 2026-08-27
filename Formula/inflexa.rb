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
  version "0.18.2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.2/inflexa-darwin-arm64"
      sha256 "ea9dc388565e6cf17dcc88f97b869c3a8d3faea6afad6a582d9811abefa8d523"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.2/inflexa-darwin-x64"
      sha256 "c3ab9cbebea4031cd626889ee8e997a56584f19d49da26b8b22955f8a87f0c73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.2/inflexa-linux-arm64"
      sha256 "586010ac215323091c2513a1b2dde4f423b34a5877d533778069217205378380"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.2/inflexa-linux-x64"
      sha256 "d74dc3e8086fbc886499aaae5f7eb77afb44175c66fae3eda3364729996e7faa"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.2/THIRD-PARTY-NOTICES.txt"
    sha256 "bc1029ecb1f91080b21f754b4045ec8a8e280a53a08122e1ee0edb264cc6af3d"
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
