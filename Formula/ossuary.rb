class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.25.0/ossuary-v0.25.0-macos-universal.tar.gz"
    sha256 "c575f7015f8386111cc64abdad63a19079938f0f13c8ea273d82f5fac4eb91f5"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.25.0/ossuary-v0.25.0-x86_64-linux-musl.tar.gz"
      sha256 "47e108c7f108a0d24c96cc5412c54852748d2a00a049196e10ee265ccabb9b92"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.25.0/ossuary-v0.25.0-aarch64-linux-musl.tar.gz"
      sha256 "faeab1b9f5f924e78d0f194f48d86cb165f76a548755d384daf498d4b5041192"
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
