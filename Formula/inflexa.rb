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
  version "0.11.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.11.0/inflexa-darwin-arm64"
      sha256 "97a56b40466770319d5913193dd261da870f10ceed8b03923ffd3ef8fc0d2f42"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.11.0/inflexa-darwin-x64"
      sha256 "19bb3dd7a3ab614d9bc21c713d91cd9990c06d980b2b7bfa9b9094ea58e60dd7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.11.0/inflexa-linux-arm64"
      sha256 "797c7ff90e68b2598abf8e2640a384368922bd9682e1b039f7808589fd2208c3"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.11.0/inflexa-linux-x64"
      sha256 "e2ac5c0e1a135baafd5d99897053b75b46ddd9cc438cbd10095073df37ca43c6"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.11.0/THIRD-PARTY-NOTICES.txt"
    sha256 "a2a98ea5fd4186b6fceb3667f7e76a22f6fea09724376295b75e4297091ad392"
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
