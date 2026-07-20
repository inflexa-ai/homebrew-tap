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
  version "0.4.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.0/inflexa-darwin-arm64"
      sha256 "508ec7f5fad99fdd5ec74c074392b4c6187400662e71f2605c860faae73bfd25"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.0/inflexa-darwin-x64"
      sha256 "fcb6f68eb3e54eaafd9de623b12f4f2f6a8d447c90b9d3b9ca8013a6208912db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.0/inflexa-linux-arm64"
      sha256 "66f0e595d888deee33ca7f080546319e662514abefa2406e65bfd19a2dabf675"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.0/inflexa-linux-x64"
      sha256 "08626b0dc062ed93403672692ecb8087ceddf8e5790568ced7ab9ccaff2ed8e4"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.4.0/THIRD-PARTY-NOTICES.txt"
    sha256 "bbdd7902f4544c2273afe1accb992ec5eee299e95d396f1204a8a20bbe667108"
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
