class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.18.0/ossuary-v0.18.0-macos-universal.tar.gz"
    sha256 "4a3b6ca1f6afb2fd17e09da22cd518c60da30f66364cc4dff9db05ec0ea25472"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.18.0/ossuary-v0.18.0-x86_64-linux-musl.tar.gz"
      sha256 "796a5cfe3cc318082e7a1913ac647f056e5553efc9be50610075f8d48a251cf8"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.18.0/ossuary-v0.18.0-aarch64-linux-musl.tar.gz"
      sha256 "f4ea7376c77a5a30e637484c42ce1b84921307839a2fa10080069de2f1631398"
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
