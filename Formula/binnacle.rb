class Binnacle < Formula
  desc "macOS system control MCP server — Calendar, Reminders, Shortcuts, and more from AI tools"
  homepage "https://github.com/seayniclabs/binnacle"
  url "https://github.com/seayniclabs/binnacle.git", tag: "v0.1.0"
  license "MIT"

  depends_on xcode: ["16.3", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    system "codesign", "--force", "--sign", "-",
           "--entitlements", "Sources/Binnacle/Binnacle.entitlements",
           ".build/release/Binnacle"
    bin.install ".build/release/Binnacle" => "binnacle"
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
