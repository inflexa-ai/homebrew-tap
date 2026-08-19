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
  version "0.16.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.1/inflexa-darwin-arm64"
      sha256 "dab8c53d0aa7adfb67c375fc267a5c0587d2c884fee18d918d39f42a0ad277b8"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.1/inflexa-darwin-x64"
      sha256 "cd4f882a9c04042f16f360f02d028b3b63c5dc3a736dc4e6f0b8c72e343baeeb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.1/inflexa-linux-arm64"
      sha256 "9892d2fb9190ce9f8382335399c02a9d8c0361d151b6e946407d969d7703669f"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.1/inflexa-linux-x64"
      sha256 "2507ff943988f39e74c5c060c723c0579fa29ed75b7c455f8d470de0544b69a0"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.1/THIRD-PARTY-NOTICES.txt"
    sha256 "0e704a5db60493042e3d4c4ca537c87d67584af5109045b6c432e5400f8a910c"
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
