class Stem < Formula
  desc "Apple Music MCP server — search, play, and manage Apple Music from AI tools"
  homepage "https://github.com/seayniclabs/stem"
  url "https://github.com/seayniclabs/stem.git", tag: "v0.1.1"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/Stem" => "stem"
  end

  def caveats
    <<~EOS
      Run the setup command to grant Apple Music access:

        stem setup

      Then add Stem to your AI tool:

        claude mcp add stem -- #{bin}/stem
    EOS
  end

  test do
    assert_match "Stem", shell_output("#{bin}/stem setup 2>&1", 1)
  end
end
