class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.23.0/ossuary-v0.23.0-macos-universal.tar.gz"
    sha256 "ef3fc038fe3a5c40a46d2745135602bb2bb62397f92e1d8165849a860e36e10e"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.23.0/ossuary-v0.23.0-x86_64-linux-musl.tar.gz"
      sha256 "5abe91eb09e468963c480004f453360804e21479648c28232e5dc94426f86e5a"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.23.0/ossuary-v0.23.0-aarch64-linux-musl.tar.gz"
      sha256 "f0dd9b1b45b7b817330774bf94abe578ec5929fc0f4e73735f23dc7ba563b573"
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
