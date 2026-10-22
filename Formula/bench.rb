class Bench < Formula
  desc "USB hardware discovery MCP server — identify devices and serial ports from AI tools"
  homepage "https://github.com/seayniclabs/bench"
  url "https://github.com/seayniclabs/bench.git", tag: "v0.2.0"
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
    require "open3"
    init = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":' \
           '{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"brew","version":"0"}}}'
    Open3.popen3(bin/"bench") do |stdin, stdout, _stderr, wait|
      stdin.puts init
      stdin.flush
      assert_match '"name":"bench"', stdout.gets
      stdin.close
      wait.value
    end
  end
end
