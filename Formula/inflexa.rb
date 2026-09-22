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
  version "0.21.5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.5/inflexa-darwin-arm64"
      sha256 "60f5a97fe355db447e2d92a8f652d1f30dff0b4f106b77f2910cc04bc25e929b"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.5/inflexa-darwin-x64"
      sha256 "fbe7736e99dfe904f70413c06457dce57ddaab6fc20423f5bbfd3c0e8f65e381"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.5/inflexa-linux-arm64"
      sha256 "90b88539d934d348b2981e5371e228df6a3f057ca796f7cb95ec1c29246a6285"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.5/inflexa-linux-x64"
      sha256 "2d9069410aab579b3e90d84d10dff03755f6fcc622f913aec381984203146048"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.5/THIRD-PARTY-NOTICES.txt"
    sha256 "ad1993133386907372dcd3c5d9d9c16ae8de90be92214df59f4546f583c48750"
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
