class Exorcise < Formula
  desc "Remove reader-application leftovers from EPUB files"
  homepage "https://github.com/sniner/exorcise"
  url "https://github.com/sniner/exorcise/releases/download/v0.1.1/exorcise-v0.1.1-macos-universal"
  sha256 "151861432bc03f47a41fc833d4cbf9da0f8e88740549681b103a17178e885534"
  license "GPL-3.0-or-later"

  depends_on :macos

  def install
    bin.install "exorcise-v#{version}-macos-universal" => "exorcise"
    # A release asset downloaded as a bare file has no executable bit.
    chmod 0755, bin/"exorcise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exorcise --version")
  end
end
