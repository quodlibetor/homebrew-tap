class GitInstafix < Formula
  desc "Apply staged git changes to an ancestor git commit.
"
  homepage "https://github.com/quodlibetor/git-instafix"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.6/git-instafix-aarch64-apple-darwin.tar.xz"
      sha256 "744d0c4dd2386a29cd6e2f6fa5085da13c8a57bd466ad177550142bef28dd1b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.6/git-instafix-x86_64-apple-darwin.tar.xz"
      sha256 "c9cadf284fc4c260107d11e7522c458563cfb737409bbf501d93de5ccc6c0581"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.6/git-instafix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a519e55f692dc890ee3684f5913ff0fa1e1f4bf9b5cad05784695fa1a58090f7"
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
