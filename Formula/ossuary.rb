class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.19.0/ossuary-v0.19.0-macos-universal.tar.gz"
    sha256 "a212fe5ba3aae03bfe88485c454fa51058daac651e973c8e157dedb31c50405b"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.19.0/ossuary-v0.19.0-x86_64-linux-musl.tar.gz"
      sha256 "19a9e0a5621d5faf9c63e39b08acfee40881be02a4e4b60ffbfbe6a49ccbcadf"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.19.0/ossuary-v0.19.0-aarch64-linux-musl.tar.gz"
      sha256 "0ccf3fd7a60261f949408700539d073e89308a39d32bc9957ecc587ac11c243d"
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
