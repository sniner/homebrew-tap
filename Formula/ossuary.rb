class Ossuary < Formula
  desc "Personal archive of everything, with everything known about it"
  homepage "https://github.com/sniner/ossuary"
  license "Apache-2.0"

  # ossuary-extract-pdf reads documents through poppler's pdftotext.
  depends_on "poppler"

  on_macos do
    url "https://github.com/sniner/ossuary/releases/download/v0.27.3/ossuary-v0.27.3-macos-universal.tar.gz"
    sha256 "a11998fe375cec7bbef2f20c19854dae46ad81f6f2e84c919d625994ab87d58d"
  end

  on_linux do
    on_intel do
      url "https://github.com/sniner/ossuary/releases/download/v0.27.3/ossuary-v0.27.3-x86_64-linux-musl.tar.gz"
      sha256 "d23baba44e6d2b3a6cf3c8309b19455b4d32ef7e5d96641182518acc283ba154"
    end
    on_arm do
      url "https://github.com/sniner/ossuary/releases/download/v0.27.3/ossuary-v0.27.3-aarch64-linux-musl.tar.gz"
      sha256 "43686295dbc2ab79bd81c0adfdcf54e7377d482a03ec983026ad02f8b1948e20"
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
