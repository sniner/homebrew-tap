class Viddeck < Formula
  desc "Browse and play a local video collection in the web browser"
  homepage "https://github.com/sniner/viddeck"
  url "https://github.com/sniner/viddeck/releases/download/v0.5.1/viddeck-v0.5.1-macos-universal"
  sha256 "96aa393c93d1f2fc15fbd6502ebd8fbf14e2d8b6bb16b734525d350ddc0624c9"
  license "Apache-2.0"

  depends_on "ffmpeg"
  depends_on :macos

  def install
    bin.install "viddeck-v#{version}-macos-universal" => "viddeck"
    # A release asset downloaded as a bare file has no executable bit.
    chmod 0755, bin/"viddeck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/viddeck --version")

    library = testpath/"videos"
    library.mkpath
    port = free_port
    pid = spawn bin/"viddeck", "--port", port.to_s, "--read-only", library
    begin
      status = JSON.parse(shell_output("curl --silent --retry 10 --retry-connrefused " \
                                       "--retry-delay 1 http://127.0.0.1:#{port}/api/videos"))
      assert status["read_only"]
      assert_empty status["videos"]
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
