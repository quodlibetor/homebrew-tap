class S3glob < Formula
  desc "A fast aws s3 ls and downloader that supports glob patterns"
  homepage "https://github.com/quodlibetor/s3glob"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.7/s3glob-aarch64-apple-darwin.tar.xz"
      sha256 "694b907f8fa728c5f3956fdf44c25188f38529dd73ab8b5d5e467d305cbbe79c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.7/s3glob-x86_64-apple-darwin.tar.xz"
      sha256 "7e3d98366e6fdafa0c2ae54590ef2ce7613c40fe073c4331440b52dd84aa5370"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.7/s3glob-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "00b42be34a7f900b0a02896cb30fd8392f36dd67e94df2b32c3a474b2d66db43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.2.7/s3glob-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "327c94a278f79e01cfb7b421a3d223c20457f065f40b77915e45077d580fc37a"
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
