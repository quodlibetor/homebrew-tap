class VcsStatusDaemon < Formula
  desc "A tool that caches VCS (jj/git) status so your shell prompt can be fast"
  homepage "https://github.com/quodlibetor/vcs-status-daemon"
  version "0.0.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.10/vcs-status-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "777f08b525fbb97d82782cad25adb1a7415b806572d99f84ce01bf850c735b9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.10/vcs-status-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "366fd19e96f79b6cd841965df78cd6010b338849fccc9a9d3b52e313628c6e92"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.10/vcs-status-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe87dfb0cfd5c56d4f594ad834537f2fb88b108596cf5e0bb8c153c2da332c82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/vcs-status-daemon/releases/download/v0.0.10/vcs-status-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18311b033842457d1a9a1bb3acce919abeaa9ba60b2baca6a440de22401859ae"
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
