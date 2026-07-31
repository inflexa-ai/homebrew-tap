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
  version "0.9.1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.1/inflexa-darwin-arm64"
      sha256 "11c66b0ad4fff8db25948912f4a796460182982b9693db1455ef3d0615e2ad08"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.1/inflexa-darwin-x64"
      sha256 "ed2f8b24a0e61736165b60fea57f7a07cd3edddd886154e4c0a6188696aa00fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.1/inflexa-linux-arm64"
      sha256 "66caccbc5003baf6419572a13a2b062c4eed8af174864f3507a477f7bafdf3c1"
    end
    on_intel do
      url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.1/inflexa-linux-x64"
      sha256 "3dcb411de43a888f5a9b76bc6371ddd1d8f5950c0802054980f1ac38cc1b8e0a"
    end
  end

  # The binary compiles its dependencies in, which makes every install a
  # redistribution of them — their license/NOTICE texts must ship alongside
  # the executable (see the build script's third-party-notices rationale).
  resource "third-party-notices" do
    url "https://github.com/inflexa-ai/inflexa/releases/download/v0.9.1/THIRD-PARTY-NOTICES.txt"
    sha256 "3cbac1a20c7f896cb0e55cece3a6152db2d8ca206cf016792ccba89cc919b18a"
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
