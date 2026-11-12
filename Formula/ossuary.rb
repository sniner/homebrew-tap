class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.22.0/ossuary-v0.22.0-macos-universal.tar.gz"
    sha256 "0ff2266db2b80a7bfa9c91caa0cce886cea5b7d23ec2628dd3dbf76acc78f83d"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.22.0/ossuary-v0.22.0-x86_64-linux-musl.tar.gz"
      sha256 "39ecbe9d9a1933a0006e05c3d12ef4727ad05bfe18f6d87bc38ac9d1499eae8e"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.22.0/ossuary-v0.22.0-aarch64-linux-musl.tar.gz"
      sha256 "720eaddb8eac00a3d8b0d6face3cbc7c9c66ff6f171268e32f0ab53ab2fdd870"
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
