class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.11.1/ossuary-v0.11.1-macos-universal.tar.gz"
    sha256 "dae54b539e0ef45fdcd6fba5c726605381ecae9c8dafef76e1f3d6fbeacd56e8"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.11.1/ossuary-v0.11.1-x86_64-linux-musl.tar.gz"
      sha256 "f6e9ca86888206fe6e1902ea037dd92e349d405bb343dd6179fc7e1ead7d92ad"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.11.1/ossuary-v0.11.1-aarch64-linux-musl.tar.gz"
      sha256 "73f2a4dde509efedca4e600d1fc1ba49b8a56f6833bac878710e285bc6588e12"
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
