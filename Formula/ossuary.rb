class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.16.0/ossuary-v0.16.0-macos-universal.tar.gz"
    sha256 "6137a01f16f12937c7acf48a69604c649027adf164165cd8f052f96283777f91"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.16.0/ossuary-v0.16.0-x86_64-linux-musl.tar.gz"
      sha256 "55660a36d730323711c1809004b70552692d638748fdef89b7bab0c95e92e137"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.16.0/ossuary-v0.16.0-aarch64-linux-musl.tar.gz"
      sha256 "5afaa1ec6acde7c330f5994a834817929fa48468ae64960297266b6c2a7762ea"
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
