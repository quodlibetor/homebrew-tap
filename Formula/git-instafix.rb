class GitInstafix < Formula
  desc "Apply staged git changes to an ancestor git commit.
"
  version "0.2.1"
  on_macos do
    on_arm do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.1/git-instafix-aarch64-apple-darwin.tar.xz"
      sha256 "d7a99ad6e651d900b536cfc881993f9ac53cae4699f99bf5c99143be098bd417"
    end
    on_intel do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.1/git-instafix-x86_64-apple-darwin.tar.xz"
      sha256 "7b437e72d585974ebbd84b291abdcace324ae8ef93d60dca3a2c755f71dd3fcf"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.1/git-instafix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0942f2fed887b8543ddc97cdbbebfb7b3b94dc6294a0676acb61dc3f819dfdca"
    end
  end

  def install
    on_macos do
      on_arm do
        bin.install "git-instafix"
      end
    end
    on_macos do
      on_intel do
        bin.install "git-instafix"
      end
    end
    on_linux do
      on_intel do
        bin.install "git-instafix"
      end
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install *leftover_contents unless leftover_contents.empty?
  end
end
