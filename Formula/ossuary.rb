class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.12.2/ossuary-v0.12.2-macos-universal.tar.gz"
    sha256 "8566f33ce1c27c3be097085c5814c1dfe24779fd4e157e6c9886b1239e1454cb"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.12.2/ossuary-v0.12.2-x86_64-linux-musl.tar.gz"
      sha256 "12f20df20012b808520d73154b9a95950f0a47a0dc92fa69b43b5e90d0573167"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.12.2/ossuary-v0.12.2-aarch64-linux-musl.tar.gz"
      sha256 "56393aa239935626f01d0085602ca5025584396d57e996ca967f928a4b2c0d01"
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
