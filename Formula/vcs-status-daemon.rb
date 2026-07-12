class VcsStatusDaemon < Formula
  desc "A tool that caches VCS (jj/git) status so your shell prompt can be fast"
  homepage "https://github.com/quodlibetor/vcs-status-daemon"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.14/vcs-status-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "94be46d97f31ec68ee8a9540c1b37873dd466e83dfafdade9640a57074fa8af9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.14/vcs-status-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "ec16f676449c3af355edd24c5fa197b67de422bd60daf9cb5f2c1af6c2f31b9b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.14/vcs-status-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce0d5b4806219a9a93a2f2182734be6ca7e00524f8c18b71f1bef5237d40a7cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.14/vcs-status-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b6f43c487629879f45b09fc8552ac5c0149a169ddc1fbd6b3449ec4857c2c4ec"
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
