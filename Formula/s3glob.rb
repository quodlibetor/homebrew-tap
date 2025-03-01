class S3glob < Formula
  desc "A fast aws s3 ls and downloader that supports glob patterns"
  homepage "https://github.com/quodlibetor/s3glob"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.4.3/s3glob-aarch64-apple-darwin.tar.xz"
      sha256 "5695fb8c446c2c78f9bc0a741228815d12fb12e71b6111e9789d4957c0e888bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.4.3/s3glob-x86_64-apple-darwin.tar.xz"
      sha256 "6ba6ffe8b0b6649973e8f59f5e6bce005150c47ad77b39897f481fd9a0cfffa5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.4.3/s3glob-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "973fcf9878388d22ed149410bac5d946b3a0a31650af85902b9c2aa3e2470d0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.4.3/s3glob-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fcd6768a5d53c35ebe3baf843ca42c2eb7ecc7c5275569db3db013941e805004"
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
    bin.install "s3glob" if OS.mac? && Hardware::CPU.arm?
    bin.install "s3glob" if OS.mac? && Hardware::CPU.intel?
    bin.install "s3glob" if OS.linux? && Hardware::CPU.arm?
    bin.install "s3glob" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
