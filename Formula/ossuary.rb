class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.21.0/ossuary-v0.21.0-macos-universal.tar.gz"
    sha256 "d093bdce51fa4eb0c6d2af06411ccfaa1295e7ad599c24dc35296d605803603b"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.21.0/ossuary-v0.21.0-x86_64-linux-musl.tar.gz"
      sha256 "0ad2153f4b41ae4baa7c14474dc6463bd8716b5d988e1dc62919901e4128e988"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.21.0/ossuary-v0.21.0-aarch64-linux-musl.tar.gz"
      sha256 "4ae55e30f1a0c3a90559b30f2ae80a43daac6b25e07199830382d96893f2cc3c"
    end
  end

  def install
    bin.install "ossuary", "ossuary-mount", "ossuary-mailvault", "ossuary-fix",
                "ossuary-sync", "ossuary-extract-image", "ossuary-extract-mail",
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
    assert_match version.to_s, shell_output("#{bin}/ossuary-sync --version")
    assert_match "pdf", shell_output("#{bin}/ossuary-extract-pdf --identify")
  end
end
