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
  version "0.21.4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.4/inflexa-darwin-arm64"
      sha256 "f56db7b8fa28d156ac71702695c0b15b8fd501cb32056e90cc0bba895641b07a"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.4/inflexa-darwin-x64"
      sha256 "8a0e8c4db84c261483a7814da33c7dec3d4dd4ddc07f7818cd99d51c0ee3d031"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.4/inflexa-linux-arm64"
      sha256 "fa3ec6ab043c0274a3486821bb2e9e89f64f8312bc85f296c54d425a2ae1afe4"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.4/inflexa-linux-x64"
      sha256 "2d2f3409ebe8ff9b568e23247d8cf15dee13cb5d10bd9caa8ee0b852b711147d"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.21.4/THIRD-PARTY-NOTICES.txt"
    sha256 "12ac4b14126d7963627eb96dc54fd14ad31fc9700ecd61ad8208218b93d9daf8"
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
