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
  version "0.16.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.0/inflexa-darwin-arm64"
      sha256 "c9403ef0994792f51ecc3ea006472ea80038d5ac4b0e148995948d524dcea506"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.0/inflexa-darwin-x64"
      sha256 "1a7fdbb0d1cec364f8b876d61730b8f7416e1c2eaed654658431efbdaa314882"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.0/inflexa-linux-arm64"
      sha256 "3761bfad2aae05547fcfda48e4b20ef8417e71482b3aca97cdfb8a91b0f3b101"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.0/inflexa-linux-x64"
      sha256 "6157f0413a9807c13de7663443aa59b2d25c107bfb8a65ae60dbab206a8ec857"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.16.0/THIRD-PARTY-NOTICES.txt"
    sha256 "d9e7502b9bdfc4a37bc96b35eb8061443dea429796efeafa654929f4e9b75e9a"
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
