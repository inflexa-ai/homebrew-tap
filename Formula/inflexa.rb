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
  version "0.18.3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.3/inflexa-darwin-arm64"
      sha256 "c56b084f87f355bf89067328e5a45ee0ada138b892bfb37fd681f5537445d567"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.3/inflexa-darwin-x64"
      sha256 "e8c6ef6a0a920fbf8e469a3a66e76def42967ed66fe21d461501bb13a48aba75"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.3/inflexa-linux-arm64"
      sha256 "9cf156d2db52a2287570d2ad09e818095b681dcb7ecbe45c374b18169271dd07"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.3/inflexa-linux-x64"
      sha256 "04edac323473fac3e7fb160d48594d8b8ad63147d122e6e65eddcc8e1afc87d9"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.18.3/THIRD-PARTY-NOTICES.txt"
    sha256 "b472f353eb9a4b588d6d2c6efd3b3b9cbfcfa1f0266d6358c14ed5ca27006858"
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
