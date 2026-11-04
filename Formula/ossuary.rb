class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.16.1/ossuary-v0.16.1-macos-universal.tar.gz"
    sha256 "7d18d93fadf6175f0178694400350fead022794f382254212ec69260354efeec"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.16.1/ossuary-v0.16.1-x86_64-linux-musl.tar.gz"
      sha256 "3e375e6ef87aa762bde7f306f776a99a95daee93a4fe9c453228170ceacdf2ec"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.16.1/ossuary-v0.16.1-aarch64-linux-musl.tar.gz"
      sha256 "7b7ab15467ede865c59b770e91e1db1bc237bc5e5e1842523d36beb0edb32a3b"
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
