class StdoutScanner < Formula
  desc "Infrastructure scanner for StdOut — Docker, network, host metrics from the CLI"
  homepage "https://github.com/charlieseay/stdout-scanner"
  url "https://github.com/charlieseay/stdout-scanner/releases/download/v2.1.0/stdout-scanner-2.1.0-darwin-arm64.tar.gz"
  sha256 "e9a7c215249f40bd9f916dbd9380efc7632da2fa1dad90d471f5f3857e65599e"
  version "2.1.0"
  license :cannot_represent

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "stdout-scanner"
  end

  def caveats
    <<~EOS
      Run the setup wizard to configure your StdOut instance:

        stdout-scanner init

      Or run a local scan immediately:

        stdout-scanner scan --output json
    EOS
  end

  test do
    assert_match "stdout-scanner 2.1.0", shell_output("#{bin}/stdout-scanner version")
  end
end
