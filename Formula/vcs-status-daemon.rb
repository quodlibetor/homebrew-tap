class VcsStatusDaemon < Formula
  desc "A tool that caches VCS (jj/git) status so your shell prompt can be fast"
  homepage "https://github.com/quodlibetor/vcs-status-daemon"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.8/vcs-status-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "eacd2e85c62a21c5b6c3ef62c62120d51116f903a12a399b0f7318dcdee0d443"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.8/vcs-status-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "76e0f9f9a466ac47ece4eaf46fa7e4aa7ab81fb7fc1c817a47e8bddf6c9cbc4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.8/vcs-status-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18e677f8dc38167698954950ed269c37052630cfaa2bde1d2cdbf12a11dbaf5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.8/vcs-status-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c53a8a308e7c44c989e01c63934e794fae33831eda73a12adf3b6545c4f3530d"
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
