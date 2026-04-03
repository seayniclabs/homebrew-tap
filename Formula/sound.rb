class Sound < Formula
  desc "Apple Music MCP server — search, play, and manage Apple Music from AI tools"
  homepage "https://github.com/seayniclabs/sound"
  url "https://github.com/seayniclabs/sound.git", tag: "v1.0.0"
  license "MIT"

  depends_on xcode: ["16.3", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    system "codesign", "--force", "--sign", "-",
           "--entitlements", "Sources/Sound/Sound.entitlements",
           ".build/release/Sound"
    bin.install ".build/release/Sound" => "sound"
  end

  def caveats
    <<~EOS
      Run the setup command to grant Apple Music access:

        sound setup

      Then add Sound to your AI tool:

        claude mcp add sound -- #{bin}/sound
    EOS
  end

  test do
    assert_match "Sound", shell_output("#{bin}/sound setup 2>&1", 1)
  end
end
