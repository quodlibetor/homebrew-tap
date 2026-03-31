class VcsStatusDaemon < Formula
  desc "A tool that caches VCS (jj/git) status so your shell prompt can be fast"
  homepage "https://github.com/quodlibetor/vcs-status-daemon"
  version "0.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.13/vcs-status-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "a595f73350e7ae9c6bf7febca5ca5de859dcb201a0dfb79cd3bc6a9da12e3581"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.13/vcs-status-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "1a31c9fe2f6963e46147b446af88ee86d44bc56f7ef6f2268622da5f04968abc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.13/vcs-status-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6372d0aa5e824673e7eb40d5a37230f4c5a110980a30935bd05117ff3170416b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.13/vcs-status-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c136f37624b6535521235f79f5b0f33816df7eb47b5cc2cbc2702b658cdb500"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "vcs-status-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "vcs-status-daemon" if OS.mac? && Hardware::CPU.intel?
    bin.install "vcs-status-daemon" if OS.linux? && Hardware::CPU.arm?
    bin.install "vcs-status-daemon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
