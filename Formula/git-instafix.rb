class GitInstafix < Formula
  desc "Apply staged git changes to an ancestor git commit.
"
  version "0.2.2"
  on_macos do
    on_arm do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.2/git-instafix-aarch64-apple-darwin.tar.xz"
      sha256 "8cf687789089761ebac72ff3cec58dcf5d9968b89f22380d236c7d8e92ff97e6"
    end
    on_intel do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.2/git-instafix-x86_64-apple-darwin.tar.xz"
      sha256 "1d19bb3074581b82ffeef9f8c507f57e45e7ef4e93918b52a76a97074c5b4e16"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/quodlibetor/git-instafix/releases/download/v0.2.2/git-instafix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "818851f43b69182387ff1437982077a5ce426c19c91ca55c56cfcb75d0bcc1ae"
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
