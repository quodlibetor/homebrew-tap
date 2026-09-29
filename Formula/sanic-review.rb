class SanicReview < Formula
  desc "Human-guided LLM review of GitHub PRs."
  homepage "https://github.com/quodlibetor/sanic-review"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/sanic-review/releases/download/v0.0.1/sanic-review-aarch64-apple-darwin.tar.xz"
      sha256 "082d4f1e95b4af5006826d72ba3f846865a408ee3bc7e6c78833b6af6a6d8f7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/sanic-review/releases/download/v0.0.1/sanic-review-x86_64-apple-darwin.tar.xz"
      sha256 "decf710746ec5f942a74c472156659e48c46455c710cf201f8c53852e2008b9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/sanic-review/releases/download/v0.0.1/sanic-review-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f5de2c9d700aaa1ecc13d3dd1c0ccf754d8aa401707c511c2e232fe7d290e09a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/sanic-review/releases/download/v0.0.1/sanic-review-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6ec62f71effd7fe3eab710a65337c105a55c1a73cce62ffce9e15f27c8e82cb9"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "sanic-review"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sanic-review"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sanic-review"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sanic-review"
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
