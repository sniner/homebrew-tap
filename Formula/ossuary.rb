class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.10.0/ossuary-v0.10.0-macos-universal.tar.gz"
    sha256 "d872ee16ae13c88e35f3489b0fe0453eb51a531f920f82c0d46a267e265d8e09"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.10.0/ossuary-v0.10.0-x86_64-linux-musl.tar.gz"
      sha256 "2f41fb78328243a499d6483c56350fd60608cfb4624e172a91cd59e08bfe46df"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.10.0/ossuary-v0.10.0-aarch64-linux-musl.tar.gz"
      sha256 "089e02aa44a0153a2687a11eac5a2e7528a6672c2128b27bb6f52329aae895e1"
    end
  end

  def install
    bin.install "ossuary", "ossuary-mount", "ossuary-mailvault", "ossuary-fix",
                "ossuary-extract-image", "ossuary-extract-mail",
                "ossuary-extract-packed", "ossuary-extract-pdf"
  end

  def caveats
    on_linux do
      <<~EOS
        ossuary-mount mounts through fusermount3, which comes with your
        distribution's fuse3 package, not with Homebrew.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ossuary --version")
    assert_match version.to_s, shell_output("#{bin}/ossuary-mailvault --version")
    assert_match "pdf", shell_output("#{bin}/ossuary-extract-pdf --identify")
  end
end
