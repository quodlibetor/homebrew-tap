class JjStatusDaemon < Formula
  desc "A tool that caches jj status so your shell prompt can be fast"
  homepage "https://github.com/quodlibetor/jj-status-daemon"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/jj-status-daemon/releases/download/v0.0.2/jj-status-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "20f0e4ec681e1344198e6fa27f32791e1c47a787b27a335747abbeebabdc66ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/jj-status-daemon/releases/download/v0.0.2/jj-status-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "8e713f070483a1812489c71f763e81eb28049083c671f759dfa0627473ad747a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/jj-status-daemon/releases/download/v0.0.2/jj-status-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0363e72536dd6ff0a13ec06126c1df8e0e19309b3afe5cee456dceea68045d3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/jj-status-daemon/releases/download/v0.0.2/jj-status-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d8c6cadc4476f210383aeac29ebfc333222744465cefa1d7931f8c21f61e4d2"
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
    bin.install "jj-status-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "jj-status-daemon" if OS.mac? && Hardware::CPU.intel?
    bin.install "jj-status-daemon" if OS.linux? && Hardware::CPU.arm?
    bin.install "jj-status-daemon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
