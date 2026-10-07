class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.11.0/ossuary-v0.11.0-macos-universal.tar.gz"
    sha256 "2e40bd8ceb0338476f9c26fefe5aa770308f5f9f84fc66ab27e5150b824806f1"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.11.0/ossuary-v0.11.0-x86_64-linux-musl.tar.gz"
      sha256 "8ce4cb09d919f62556bf312c93e2c61353a38909717817cc14f48378141ba5a0"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.11.0/ossuary-v0.11.0-aarch64-linux-musl.tar.gz"
      sha256 "de32874c30e11adfdd676e1797e61f73f2be1954b1c19c4dcc0ccac7e2631034"
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
