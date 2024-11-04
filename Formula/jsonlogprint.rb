class Jsonlogprint < Formula
  desc "Pretty print json logs

For when you need to watch json logs in a terminal
and you just want them to be easier to read.
"
  homepage "https://github.com/quodlibetor/jsonlogprint"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/quodlibetor/jsonlogprint/releases/download/v0.1.0/jsonlogprint-aarch64-apple-darwin.tar.xz"
      sha256 "add06a176d03472ab5ce7eabca1f129f35085592d2950f734a617dca26123fbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/quodlibetor/jsonlogprint/releases/download/v0.1.0/jsonlogprint-x86_64-apple-darwin.tar.xz"
      sha256 "f4f744f5789bf808f0c2643a7ae3b9e66e3b71a469fb805565db291ffee8ce95"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/quodlibetor/jsonlogprint/releases/download/v0.1.0/jsonlogprint-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "af124960a2099426174d8ef055ef0ce40d75af815f6a06ab207985585b04ee35"
  end
  license "MIT or Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
    bin.install "jsonlogprint" if OS.mac? && Hardware::CPU.arm?
    bin.install "jsonlogprint" if OS.mac? && Hardware::CPU.intel?
    bin.install "jsonlogprint" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
