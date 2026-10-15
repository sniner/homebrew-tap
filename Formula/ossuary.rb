class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.12.1/ossuary-v0.12.1-macos-universal.tar.gz"
    sha256 "916b1400ac54da93a7c997fd040dd4db6c52e784f4d683b10405fadd5fa61ec3"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.12.1/ossuary-v0.12.1-x86_64-linux-musl.tar.gz"
      sha256 "1f7aef61ac8b237a0ab453814cacb48edda8cbd71156f0bd4951f952710b2290"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.12.1/ossuary-v0.12.1-aarch64-linux-musl.tar.gz"
      sha256 "ec2e6d797ae62a215ef2e924a8d8694195e2992db6ce6c0c4ff92fc24e180675"
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
