class Viddeck < Formula
  desc "Browse and play a local video collection in the web browser"
  homepage "https://github.com/sniner/viddeck"
  url "https://github.com/sniner/viddeck/releases/download/v0.5.0/viddeck-v0.5.0-macos-universal"
  sha256 "a669efd02d65dff473d48960843166da7a2a8bbcfdb1fe0e81fa477e6bf65379"
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
