class S3glob < Formula
  desc "A fast aws s3 ls and downloader that supports glob patterns"
  homepage "https://github.com/quodlibetor/s3glob"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.4/s3glob-aarch64-apple-darwin.tar.xz"
      sha256 "a17d0462de802187084d90b59639d411ff2aa590e69a42e0a6ebed64f289e163"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.4/s3glob-x86_64-apple-darwin.tar.xz"
      sha256 "925285020af2514fdcbdfb6d0a99c947d9e99f071ff7979582709016628bf686"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.4/s3glob-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b40cbe42b4796262ed5d7f9275c0e69141364e7e8e534f4daae555d3bb3a627"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.4/s3glob-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ded8ac9df62459e83bc1fda33edd446d5145adcb37f1ce3e3f6c13d1128f95ee"
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
