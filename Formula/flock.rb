class Flock < Formula
  desc "Run a command while holding an atomic, OS-managed, death-safe file lock"
  homepage "https://github.com/quodlibetor/flock"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.1/flock-aarch64-apple-darwin.tar.xz"
      sha256 "efa4ad0e853dfe767bf6d95371d6619dbf4dfc08b0ce1f9ba09536b620e5a21c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.1/flock-x86_64-apple-darwin.tar.xz"
      sha256 "4f097b7f106155f1dd4446f0996fd90a1f371dba5bc695f4b3b38870d832173e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.1/flock-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "00d64401fadc391c005e85bca12111a3b5d6d69d35da379a2448731b917bd1dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/flock/releases/download/v0.0.1/flock-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9f47a7d458ba4ca8cf7a6140153c5c2960a0f5180b6cefb408fd424136bc7773"
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
