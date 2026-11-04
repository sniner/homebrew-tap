class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.16.2/ossuary-v0.16.2-macos-universal.tar.gz"
    sha256 "65f94c3e9e8c916bc7aa499ee847db4e730a99032b7be76f38c91babf9f8895c"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.16.2/ossuary-v0.16.2-x86_64-linux-musl.tar.gz"
      sha256 "dd5933ac394bdebfc6510cf7971a74fe2b2c958d94cce96aa90a4badbf3d017e"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.16.2/ossuary-v0.16.2-aarch64-linux-musl.tar.gz"
      sha256 "86b81f630ab5f711acc2c97f60dc8c2b61e0e42f3575822fb0d0310f3cd676a3"
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
