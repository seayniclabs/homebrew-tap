class Binnacle < Formula
  desc "macOS system control MCP server — Calendar, Reminders, Shortcuts, and more from AI tools"
  homepage "https://store.seayniclabs.com/products/binnacle"
  url "https://github.com/seayniclabs/binnacle/releases/download/v0.1.0/binnacle-v0.1.0-arm64-macos.tar.gz"
  sha256 "dd468fbba7dcc4b3e39b3a6a6577aef88472112d10870081010650b18e6ffb1d"
  license "MIT"
  version "0.1.0"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "Binnacle" => "binnacle"
  end

  def caveats
    <<~EOS
      Run the setup command to grant Calendar and Reminders access:

        binnacle setup

      Then add Binnacle to your AI tool:

        claude mcp add binnacle -- #{bin}/binnacle
    EOS
  end

  test do
    assert_match "Binnacle", shell_output("#{bin}/binnacle 2>&1", 1)
  end
end
