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
  version "0.10.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.1/inflexa-darwin-arm64"
      sha256 "8f0056c43d90f41bcc5b7fb98670636ec13c4176e128e7c6549d59ddc31317ad"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.1/inflexa-darwin-x64"
      sha256 "e5d4375fc7efa8242fac2fd26e897e8db3f1b75d4e6cd725fd3531762ecf21d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.1/inflexa-linux-arm64"
      sha256 "2e9352c251774e859cfad00ece9e55626fcb93d88a164152d92417d4909bbbd5"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.1/inflexa-linux-x64"
      sha256 "68e56c8ba5b8feec904f1c2480725f632bfdbb5d9103fa4a253276d3654200e1"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.10.1/THIRD-PARTY-NOTICES.txt"
    sha256 "7c90dcaa76d7c5278bb4ca1b84157462661ac502ea03444602f4d9d417e366a8"
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
