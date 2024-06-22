class GitInstafix < Formula
  desc "Apply staged git changes to an ancestor git commit.
"
  homepage "https://github.com/quodlibetor/git-instafix"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.5/git-instafix-aarch64-apple-darwin.tar.xz"
      sha256 "2384c330762a11c2f6151714a829a51f5f97162b3b69805d7bdf705b43acd492"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.5/git-instafix-x86_64-apple-darwin.tar.xz"
      sha256 "0baa6ffd06e73dce429b8620fdbe9b300b47676e9698226cd62b393f592a0a17"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.5/git-instafix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "204f7298ee8aa8ed6f09d84aa96a4587533868298147ee21a383c6640054b848"
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
