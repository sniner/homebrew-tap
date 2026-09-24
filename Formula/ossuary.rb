class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.10.1/ossuary-v0.10.1-macos-universal.tar.gz"
    sha256 "4158c7c018429d8b7a068604106467a661b9a597e6d7d045d3015129fabf38af"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.10.1/ossuary-v0.10.1-x86_64-linux-musl.tar.gz"
      sha256 "a86d1b725b9110bdbeab06c21b4cb6e1bd848e98b8acc966225e34b9054bcf44"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.10.1/ossuary-v0.10.1-aarch64-linux-musl.tar.gz"
      sha256 "805db265f3a06717ade5bc06d8f6597a40f0a64aaa462e8b97797fabcc140146"
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
