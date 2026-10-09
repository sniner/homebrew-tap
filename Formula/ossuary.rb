class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.12.0/ossuary-v0.12.0-macos-universal.tar.gz"
    sha256 "f583fe04bcaa7cca0e9d8155e6040b469b45c46602d3c7083a30895b5e827ff6"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.12.0/ossuary-v0.12.0-x86_64-linux-musl.tar.gz"
      sha256 "d4b2438b81dc169e85033fbdbe260669bb06dc179e63b37412da518e69c60654"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.12.0/ossuary-v0.12.0-aarch64-linux-musl.tar.gz"
      sha256 "da735f2d76f09f3974b084d1b44b4f8748a2a7375a05ca0a5aa3a6e66c2d05e7"
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
