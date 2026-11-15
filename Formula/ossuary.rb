class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.24.0/ossuary-v0.24.0-macos-universal.tar.gz"
    sha256 "d520814663881b837d31e583122365214639977e08a37d79a5aea837d8233e83"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.24.0/ossuary-v0.24.0-x86_64-linux-musl.tar.gz"
      sha256 "5b183ebb83ea49583a3f32228d3d349b79860bd1f17bb26c1e72d805521752ea"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.24.0/ossuary-v0.24.0-aarch64-linux-musl.tar.gz"
      sha256 "57b6de6df02e8ba008273cd77a30dfab12e1fd98121fa01932331836443ff795"
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
