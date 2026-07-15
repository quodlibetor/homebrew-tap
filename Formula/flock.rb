class Flock < Formula
  desc "Run a command while holding an atomic, OS-managed, death-safe file lock"
  homepage "https://github.com/quodlibetor/flock"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.2/flock-aarch64-apple-darwin.tar.xz"
      sha256 "207b664b4b5b4a7c1fa5f113f7727882a7373e8b0048fe1f8415aa26a27b6e4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.2/flock-x86_64-apple-darwin.tar.xz"
      sha256 "edfb04bff992b1f89000ad255bc69833beffa08e80023ed4780c567269d440a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.2/flock-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c8e569dede722424ed98f21ad285829f1d8060c8564c58805595863134a983e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.2/flock-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1a29cc09d06c9e413bf240c50c8cdd191dc7bc4c4427944e61dc966bead2ee25"
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
