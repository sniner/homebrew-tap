class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.27.2/ossuary-v0.27.2-macos-universal.tar.gz"
    sha256 "9ffa842103c1c0f94b72bc207a6ee598ee4303ecd5523403c236f0517ce4cdd3"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.27.2/ossuary-v0.27.2-x86_64-linux-musl.tar.gz"
      sha256 "0eb0123a5bdc48394d178e01c7c02257cc947d6aa8decc1622fc633e214ae77e"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.27.2/ossuary-v0.27.2-aarch64-linux-musl.tar.gz"
      sha256 "defe82023f973266aa2727211a14fc908208ba556972aea49d0093a8f9803441"
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
