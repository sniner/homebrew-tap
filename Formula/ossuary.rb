class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.17.0/ossuary-v0.17.0-macos-universal.tar.gz"
    sha256 "d599e71592b9c35eb57d61a76a006a5e9a859953d7554528c13f36abe9e8fb80"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.17.0/ossuary-v0.17.0-x86_64-linux-musl.tar.gz"
      sha256 "57ba16f13ed6e7bc4cfdf01f9a8ad0cd4e686b254f0b56e1235d51319cb13c7e"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.17.0/ossuary-v0.17.0-aarch64-linux-musl.tar.gz"
      sha256 "3065dc8529273ea296cff02bb8b3411edb76870313231e8cb6fecf501726f9ee"
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
