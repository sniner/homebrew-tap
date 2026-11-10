class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.20.3/ossuary-v0.20.3-macos-universal.tar.gz"
    sha256 "08782b9ccf8ad06afe1f55b3cb8196a8e7277549280cd27e5448e6f3a8af9948"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.20.3/ossuary-v0.20.3-x86_64-linux-musl.tar.gz"
      sha256 "4d0f6ad7695e4b93e4969fdbdfcb71705da14f93e2f3d3f0e1ca2667a30d305c"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.20.3/ossuary-v0.20.3-aarch64-linux-musl.tar.gz"
      sha256 "79e184782515c6378cbae189ac8dc892dee119b34951642e7d2bcb6a20c89105"
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
