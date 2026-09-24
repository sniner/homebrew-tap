class Fifi < Formula
  desc "Find identical files in subdirectories"
  homepage "https://github.com/sniner/fifi"
  url "https://github.com/sniner/fifi/releases/download/v0.7.1/fifi-v0.7.1-macos-universal"
  sha256 "06bb07b932255257d946a5ac59455897b5742447a1c9f331470b6c1c65d2e937"
  license "GPL-3.0-or-later"

  depends_on :macos

  def install
    bin.install "fifi-v#{version}-macos-universal" => "fifi"
    # A release asset downloaded as a bare file has no executable bit.
    chmod 0755, bin/"fifi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fifi --version")

    files = testpath/"files"
    files.mkpath
    (files/"a.txt").write "same content"
    (files/"b.txt").write "same content"
    (files/"c.txt").write "other content"
    # fifi exits with 1 when it finds duplicates.
    report = JSON.parse(shell_output("#{bin}/fifi --json #{files}", 1))
    assert_equal 1, report["statistics"]["duplicate_groups"]
  end
end
