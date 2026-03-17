class Bench < Formula
  desc "USB hardware discovery MCP server — identify devices and serial ports from AI tools"
  homepage "https://github.com/seayniclabs/bench"
  url "https://github.com/seayniclabs/bench.git", tag: "v0.1.0"
  license "MIT"

  depends_on xcode: ["16.3", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    system "codesign", "--force", "--sign", "-",
           "--entitlements", "Sources/Bench/Bench.entitlements",
           ".build/release/Bench"
    bin.install ".build/release/Bench" => "bench"
  end

  def caveats
    <<~EOS
      Add Bench to your AI tool:

        claude mcp add bench -- #{bin}/bench
    EOS
  end

  test do
    assert_match "Bench", shell_output("#{bin}/bench 2>&1", 1)
  end
end
