class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.14.0/ossuary-v0.14.0-macos-universal.tar.gz"
    sha256 "da78237bf0126b314e9b6bf1333c06d75a09340f45619810391c2aeeb7c391f9"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.14.0/ossuary-v0.14.0-x86_64-linux-musl.tar.gz"
      sha256 "8a6cade098e42acd526aafd7c8fc9eb03752405bccd9a8f03acd5a28a68ee77f"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.14.0/ossuary-v0.14.0-aarch64-linux-musl.tar.gz"
      sha256 "67653f427666cf7b7a627afcd8d2a1e74906b09ff34b8d6932e114ac9324ce9a"
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
