class S3glob < Formula
  desc "A fast aws s3 ls and downloader that supports glob patterns"
  homepage "https://github.com/quodlibetor/s3glob"
  version "0.4.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.4.18/s3glob-aarch64-apple-darwin.tar.xz"
      sha256 "544488a49fb2a30a129f941ff1aecf225da0bf587657fe0f4d8eb048692f1915"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.4.18/s3glob-x86_64-apple-darwin.tar.xz"
      sha256 "a27d23f42561ab65d403c29339cbb5e2130fb7aca9901d138f3f14949406496b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.4.18/s3glob-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f961b87ab1495f4794bb490dd6284af10706f18fc60bd3ec438ebd9b6b202076"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/s3glob/releases/download/v0.4.18/s3glob-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9431d0dcc3d74ccd6ac3443a907987d7d3b73d33262812c3f1e85dc4c51d7fa5"
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
      bin.install "s3glob"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "s3glob"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "s3glob"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "s3glob"
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
