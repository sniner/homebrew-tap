class Exhume < Formula
  desc "Resumable disk imaging and rescue tool"
  homepage "https://github.com/sniner/exhume"
  url "https://github.com/sniner/exhume/releases/download/v0.6.0/exhume-v0.6.0-macos-universal"
  sha256 "76ed550cb15cc962f3a2aefcbaedea7b1df566330826602649e3fbebf2991636"
  license "GPL-3.0-or-later"

  depends_on :macos

  def install
    bin.install "exhume-v#{version}-macos-universal" => "exhume"
    # A release asset downloaded as a bare file has no executable bit.
    chmod 0755, bin/"exhume"
  end

  def caveats
    <<~EOS
      exhume is experimental on macOS. Image a disk through its raw node
      /dev/rdiskN, which is much faster than /dev/diskN, and unmount the disk
      first with `diskutil unmountDisk`: exhume does not yet recognize every
      mounted APFS volume.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exhume --version")
  end
end
