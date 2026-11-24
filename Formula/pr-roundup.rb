class PrRoundup < Formula
  desc "A local page that groups your open pull requests by tag and copies them for Slack"
  homepage "https://github.com/quodlibetor/pr-roundup"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/pr-roundup/releases/download/v0.0.1/pr-roundup-aarch64-apple-darwin.tar.xz"
      sha256 "77104d6be03a7868d1830ec691212ba69d984db9d448420fbabe08a53623a3ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/pr-roundup/releases/download/v0.0.1/pr-roundup-x86_64-apple-darwin.tar.xz"
      sha256 "d49973455f8f13bbf91c3208697fdf0abe2c091d02ac1b6e63a3d8e858cca974"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/pr-roundup/releases/download/v0.0.1/pr-roundup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61b522b1e11e55c7327d2887f655ed323e7e1a0ae721340b75c697ec3aaa42e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/pr-roundup/releases/download/v0.0.1/pr-roundup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bee4c20b427d2c195ae1136a2e5e022a4ea6ee4a4ae1c19a94b6f9be7fb6f42e"
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
      bin.install "pr-roundup"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pr-roundup"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "pr-roundup"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pr-roundup"
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
