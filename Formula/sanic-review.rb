class SanicReview < Formula
  desc "Human-guided LLM review of GitHub PRs."
  homepage "https://github.com/quodlibetor/sanic-review"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/sanic-review/releases/download/v0.0.2/sanic-review-aarch64-apple-darwin.tar.xz"
      sha256 "7d8814d85d7dfb6a8fca892448501306579cab88020eda16a19c841c1be170b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/sanic-review/releases/download/v0.0.2/sanic-review-x86_64-apple-darwin.tar.xz"
      sha256 "098e1e7aaece3079423fc0ee243a3c56c48a62040e85bdc9011418b50fee0165"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/sanic-review/releases/download/v0.0.2/sanic-review-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67fca92a2b0a7cba70a2fa14ffba89abc0e54dcfe80761c7f53144177a257b2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/sanic-review/releases/download/v0.0.2/sanic-review-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a39780f75fa3d0a9c58b7d51652eeb4136566d2d163c427f68ac8e14e165773b"
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
