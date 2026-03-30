class VcsStatusDaemon < Formula
  desc "A tool that caches VCS (jj/git) status so your shell prompt can be fast"
  homepage "https://github.com/quodlibetor/vcs-status-daemon"
  version "0.0.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.12/vcs-status-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "c93f99c7da4fedd90f05ae5f9194acb5a573eb1d305c1444ab367caaea63623c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.12/vcs-status-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "be52f448f8dcc90b12f4ae5abc3e0384c9d8e228f916e46b190777c05b73bf41"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.12/vcs-status-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2ae71862b1ec2e6e194065a738be7399dc58a2c16f852c4df6f754dacbed083"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.12/vcs-status-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c3f3135916c02cf484d4d570bdaf07f0c4caa8874686e2060df89f9e94bc04a1"
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
