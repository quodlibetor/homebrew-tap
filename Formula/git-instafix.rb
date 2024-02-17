class GitInstafix < Formula
  desc "Apply staged git changes to an ancestor git commit.
"
  version "0.2.0"
  on_macos do
    on_arm do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.0/git-instafix-aarch64-apple-darwin.tar.xz"
      sha256 "b8680b2324a424e271830206a50781b4a5fd49946867ea2cefa1fd0990a98140"
    end
    on_intel do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.0/git-instafix-x86_64-apple-darwin.tar.xz"
      sha256 "9ce459edcfc09c97119b09fa33490525251c8c077da0f13185d884dca8956e15"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.0/git-instafix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b5ab34932a72e02dc33844a411752add4297c13795f4f2e7abe55507a99f1ae8"
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
