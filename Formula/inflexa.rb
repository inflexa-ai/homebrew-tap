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
  version "0.9.2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.2/inflexa-darwin-arm64"
      sha256 "82a2fa95bafc74005bcdb60503d8924b4e073cc46fe1195fa5cad77023055930"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.2/inflexa-darwin-x64"
      sha256 "cb05dac95dad6cc1b7217f53e28c4cfe450be7d06e08f2943a897472182399a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.2/inflexa-linux-arm64"
      sha256 "58ff763e82cd35326ee8ff1195fba0c4b7984958b4647f181e4b4f6435565d6f"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.2/inflexa-linux-x64"
      sha256 "a51847c468f3bf4f08d6c1427633e69820b71a5d337bc885ac12ac71de6ebb38"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.2/THIRD-PARTY-NOTICES.txt"
    sha256 "aed3b6e487d8a259b7cc5e6ec120398c6797b4d8d4ba26db089deeac8a904d9a"
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
