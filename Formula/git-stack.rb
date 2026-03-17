class GitStack < Formula
  desc "Helpers for working with stacked PR branches (rebase, push, log)"
  homepage "https://github.com/quodlibetor/dotfiles"
  head "https://github.com/quodlibetor/dotfiles.git", branch: "main"
  license "MIT"

  def install
    %w[git-rebasestack git-pushstack git-lgstack].each do |script|
      bin.install "dot_local/bin/executable_#{script}" => script
    end
  end

  test do
    system "#{bin}/git-rebasestack", "-h"
  end
end
