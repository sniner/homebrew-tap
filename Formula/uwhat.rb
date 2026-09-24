class Uwhat < Formula
  desc "Human-friendly USB device lister"
  homepage "https://github.com/sniner/uwhat"
  url "https://github.com/sniner/uwhat/releases/download/v0.3.0/uwhat-v0.3.0-aarch64-macos"
  sha256 "e812a8df2233f4bc4d59073731a877c1da465681a2f96ca1a8520ee9d5d97258"
  license "GPL-3.0-or-later"

  # The project releases no build for Intel Macs.
  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "uwhat-v#{version}-aarch64-macos" => "uwhat"
    # A release asset downloaded as a bare file has no executable bit.
    chmod 0755, bin/"uwhat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uwhat --version")
  end
end
