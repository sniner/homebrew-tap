class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.12.6/ossuary-v0.12.6-macos-universal.tar.gz"
    sha256 "82a0877cc7af00ae11162eacb1ef5340e2260a77508ff77448dc84d75f9b1c88"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.12.6/ossuary-v0.12.6-x86_64-linux-musl.tar.gz"
      sha256 "3eaa3ab889a67d66a061b52524ba0a4433b168588e8276d94f4033b4fbce9aef"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.12.6/ossuary-v0.12.6-aarch64-linux-musl.tar.gz"
      sha256 "745391aadc444512b477330287c1c9106185ece85728932f226aa517e8343221"
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
