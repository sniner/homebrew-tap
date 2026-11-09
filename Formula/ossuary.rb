class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.20.1/ossuary-v0.20.1-macos-universal.tar.gz"
    sha256 "d776c7625db08075e5556f952c80b75315a7b1925b0217e561237709e13bb852"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.20.1/ossuary-v0.20.1-x86_64-linux-musl.tar.gz"
      sha256 "84841e2f4d9a5aacb909cb96275d3354fed697f565f228a9c049dbe414279fe0"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.20.1/ossuary-v0.20.1-aarch64-linux-musl.tar.gz"
      sha256 "b71f085a10e1fef62b63ad1dc116318a626336ba69f83c393cb937e85efd1a05"
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
