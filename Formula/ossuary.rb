class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.27.0/ossuary-v0.27.0-macos-universal.tar.gz"
    sha256 "d73da110aa520e40281e427f20762737ee9f37f9f24f93a06f006066d27d3acd"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.27.0/ossuary-v0.27.0-x86_64-linux-musl.tar.gz"
      sha256 "97fd96c6f89da346497f475ca65bd6836b34d4d5b0210d6cac706d34423cfb28"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.27.0/ossuary-v0.27.0-aarch64-linux-musl.tar.gz"
      sha256 "1d1ccb00e5035f655815b15360e1fcebfd96a50848d84ec3319c9815ed8a03a6"
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
