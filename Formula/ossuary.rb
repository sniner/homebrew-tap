class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.24.1/ossuary-v0.24.1-macos-universal.tar.gz"
    sha256 "f30dc49d453b18157a8c1c54e29c5b32fd4bc70764ee8754a4ef7b500ad061d3"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.24.1/ossuary-v0.24.1-x86_64-linux-musl.tar.gz"
      sha256 "5d4174a445a10621c646a68569549ef06832e7fe908b459593711c47d5b480cd"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.24.1/ossuary-v0.24.1-aarch64-linux-musl.tar.gz"
      sha256 "e2f914e9864182429e4a1d809a03814c467f9c93fefb8f420f8d3a25c3ac1330"
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
