class S3glob < Formula
  desc "A fast aws s3 ls that supports glob patterns"
  homepage "https://github.com/quodlibetor/s3glob"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.1.1/s3glob-aarch64-apple-darwin.tar.xz"
      sha256 "6bc8113e23002fe3fa2383457d0e0ff5d0b3777f2a8f718e00bb2b164741c41b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.1.1/s3glob-x86_64-apple-darwin.tar.xz"
      sha256 "52e356a437a7f8e5270ef925aa45eadfac3bc609803068538ee6e5a2367f9a8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.1.1/s3glob-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "466df43dc85d075a1cff40acce264fa3f3f1796bb27629f9859fdc366c7208ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.1.1/s3glob-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b7fc438028d5ef13466f6807a1fd6c8bdef69af3e576a1370efe8e5711e7678"
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
