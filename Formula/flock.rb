class Flock < Formula
  desc "Run a command while holding an atomic, OS-managed, death-safe file lock"
  homepage "https://github.com/quodlibetor/flock"
  version "0.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.5/flock-aarch64-apple-darwin.tar.xz"
      sha256 "cdec8c30371bd9711e873fff24d1296349502fccf4ac7d507bc4d5daf1b792ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.5/flock-x86_64-apple-darwin.tar.xz"
      sha256 "6367858520e5db3464f55946449637664b024ce3a11931b7021d6e9d21504fc2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.5/flock-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e9e970b442fa4c8e6838dd5f0d143f701f7c7966291935cfdde68b7127b43526"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.5/flock-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f59f9972a997d871914766b4423e90c006a0a249a9aaaf4220c0b342bc361bd7"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "flock"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "flock"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "flock"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "flock"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
