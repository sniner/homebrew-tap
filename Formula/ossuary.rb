class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.15.0/ossuary-v0.15.0-macos-universal.tar.gz"
    sha256 "3651e7ab30963076057ce66463f5f3fb75405e9adba0770b9d0381550360ca34"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.15.0/ossuary-v0.15.0-x86_64-linux-musl.tar.gz"
      sha256 "88782a329d667f4d7ebefc29f70fd1eb4c1f0939d744829a2a1b4cc38fb6e97d"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.15.0/ossuary-v0.15.0-aarch64-linux-musl.tar.gz"
      sha256 "99084bb969cb5cac8eeeebf412317f14d3035d0c915652e7651cad781ba0b098"
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
