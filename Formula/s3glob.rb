class S3glob < Formula
  desc "A fast aws s3 ls and downloader that supports glob patterns"
  homepage "https://github.com/quodlibetor/s3glob"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.2/s3glob-aarch64-apple-darwin.tar.xz"
      sha256 "a3ed4ee5be274a0d2007b0e98a411c3958c388bccbc96992f863b578a9884de1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.2/s3glob-x86_64-apple-darwin.tar.xz"
      sha256 "3a7d341393309bb89b48d5417d1ca24f734623c807b8d7dec6f89b185dd7f086"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.2/s3glob-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "73a97a2b741758df03f0e14ed28ca663daf4281d7b8d89ad9d1444f9a4cf2b7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.2/s3glob-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6dcdc512135f8c067db30a21579ba8ce4b8ec0aaa0db49dbd65dc497cfe93404"
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
