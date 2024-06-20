class GitInstafix < Formula
  desc "Apply staged git changes to an ancestor git commit.
"
  homepage "https://github.com/quodlibetor/git-instafix"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.4/git-instafix-aarch64-apple-darwin.tar.xz"
      sha256 "55d86c6c4803b38f219aa01a5a79f551e7f54696c1dceab075351585fa3d5875"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.4/git-instafix-x86_64-apple-darwin.tar.xz"
      sha256 "feed7b6794b8ff0e0a128be51b069be4411b83fbfd183589e44ea53179319930"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.4/git-instafix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6cc89806f219bb2206535e76dc82d28fe98e812d8f14b6ea67d2714929ab6eaa"
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
