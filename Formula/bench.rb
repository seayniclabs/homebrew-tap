class Bench < Formula
  desc "USB hardware discovery MCP server: identify maker boards, serial ports and HID from AI tools"
  homepage "https://github.com/seayniclabs/bench"
  url "https://github.com/seayniclabs/bench/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "892e36980333900e9ca1ff0d88d897cc2f90bff0894660d2f2ca79435773ad47"
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

      Device-changing tools ask for approval. To pre-approve them, set
      BENCH_APPROVE_DEVICE_WRITES=1. Modules are switched with BENCH_MODULES.
    EOS
  end

  test do
    require "open3"
    init = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":' \
           '{"protocolVersion":"2025-11-25","capabilities":{},"clientInfo":{"name":"brew","version":"0"}}}'
    Open3.popen3(bin/"bench") do |stdin, stdout, _stderr, wait|
      stdin.puts init
      stdin.flush
      response = stdout.gets
      assert_match '"name":"bench"', response
      assert_match '"version":"0.3.0"', response
      stdin.close
      wait.value
    end
  end
end
