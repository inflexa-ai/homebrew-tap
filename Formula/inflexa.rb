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
  version "0.21.2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.2/inflexa-darwin-arm64"
      sha256 "99f339465e01b1bfe8ec6b5e2a1e533cc906316b3639411f8363e5ed3177e850"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.2/inflexa-darwin-x64"
      sha256 "234cbbe40f48d50688f808ddace8295465a16ad3cc38cfa40ad13d73823962ba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.2/inflexa-linux-arm64"
      sha256 "08e5cf7741935af4b1304bffc23d58324b1cdee7906639f9b302a6c6bcf63309"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.2/inflexa-linux-x64"
      sha256 "f9d0a1bf35589b77f46022d5520f4e363c76fe83b9ffbb8d88df5bf9ce17500c"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.2/THIRD-PARTY-NOTICES.txt"
    sha256 "8356ee4a76ed0279a0574db4f869d362bf5cfad1e11456f492e3b607f8e2a5ab"
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
