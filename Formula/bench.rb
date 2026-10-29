class Bench < Formula
  desc "USB hardware discovery MCP server: identify maker boards, serial ports and HID from AI tools"
  homepage "https://github.com/seayniclabs/bench"
  url "https://github.com/seayniclabs/bench/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "438771cb0422d8351bf746c4b6edfed171db8f13f4a7ebf4a5c9f862ed507ca7"
  license "MIT"

  depends_on xcode: ["16.3", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    system "codesign", "--force", "--sign", "-",
           "--entitlements", "Sources/Bench/Bench.entitlements",
           ".build/release/Bench"
    bin.install ".build/release/Bench" => "bench"
    # Skills sit beside the binary: bin/bench finds them at ../share/bench/skills.
    pkgshare.install "skills"
  end

  def caveats
    <<~EOS
      Check the install, then add Bench to your AI tool:

        #{bin}/bench --doctor

        claude mcp add bench -- #{bin}/bench

      Device-changing tools ask for approval. To pre-approve them, set
      BENCH_APPROVE_DEVICE_WRITES=1. Modules are switched with BENCH_MODULES, and
      the debug module (decode_crash) with BENCH_DEBUG_ENABLED=1.
    EOS
  end

  test do
    require "open3"
    init = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":' \
           '{"protocolVersion":"2025-11-25","capabilities":{},"clientInfo":{"name":"brew","version":"0"}}}'
    prompts = '{"jsonrpc":"2.0","id":2,"method":"prompts/list","params":{}}'
    Open3.popen3(bin/"bench") do |stdin, stdout, _stderr, wait|
      stdin.puts init
      stdin.flush
      response = stdout.gets
      assert_match '"name":"bench"', response
      assert_match '"version":"0.4.3"', response
      stdin.puts '{"jsonrpc":"2.0","method":"notifications/initialized"}'
      stdin.flush
      sleep 1
      stdin.puts prompts
      stdin.flush
      listed = stdout.gets
      # The skills must be found beside the installed binary, through the Homebrew layout.
      assert_match '"name":"getting-started"', listed
      stdin.close
      wait.value
    end
    assert_predicate pkgshare/"skills/getting-started/SKILL.md", :exist?
  end
end
