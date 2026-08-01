class Flock < Formula
  desc "Run a command while holding an atomic, OS-managed, death-safe file lock"
  homepage "https://github.com/quodlibetor/flock"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.4/flock-aarch64-apple-darwin.tar.xz"
      sha256 "0b72370ad2d4e36d4d56231c007102e5b9b2f1f67046a5774c71e6fbfab0aebf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.4/flock-x86_64-apple-darwin.tar.xz"
      sha256 "d85d3fd4e5791de9c86e13b4e9c0a68114330e586f616a8bdbf399e26eb5283c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.4/flock-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1246deab4073b83b7e442f5c31d7d8653664053da58cf1a85965991a54721bcc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.4/flock-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c33f001a95b9acc56b200dfa7ae0332caaf5d372f92f76ead9bdb1aa057075ef"
    end
  end
  license "MIT, APACHE-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
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
    bin.install "flock" if OS.mac? && Hardware::CPU.arm?
    bin.install "flock" if OS.mac? && Hardware::CPU.intel?
    bin.install "flock" if OS.linux? && Hardware::CPU.arm?
    bin.install "flock" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
