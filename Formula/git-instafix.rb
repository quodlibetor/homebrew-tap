class GitInstafix < Formula
  desc "Apply staged git changes to an ancestor git commit.
"
  homepage "https://github.com/quodlibetor/git-instafix"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.3/git-instafix-aarch64-apple-darwin.tar.xz"
      sha256 "a7e6cca7b1b06a1560748a5ef8ced9239c9316ee5c762e8fc5aad5f83e1193af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.3/git-instafix-x86_64-apple-darwin.tar.xz"
      sha256 "7c1405968bcb30445b1aa496aa3b6724bc7da342a3730079e4047c40e80b21b8"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.3/git-instafix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0296a2bd18ab6d32b28d4f6bad25369314cde7c8b9d7a019deaa520279528060"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}, "x86_64-unknown-linux-musl-dynamic": {}, "x86_64-unknown-linux-musl-static": {}}

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
      bin.install "git-instafix"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-instafix"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-instafix"
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
