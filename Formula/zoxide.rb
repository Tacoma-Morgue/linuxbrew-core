class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.3.tar.gz"
  sha256 "0b596cf8f86c51cc5aaf8914f8e47fdb0a60ba44e55d75a3d131b1f583ea098c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9ab277c34e71fe0c054e80fa7d2bdd534b072e859c44b18d1ed5d90030f180f"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e6a693a7672853ad0d148bf388fbff77620fd1e712e032099e907aeb793ceca"
    sha256 cellar: :any_skip_relocation, catalina:      "a7f3688ad3276e53c10cfb2441d8817965eb9f2c4a37df5bb5e469c963855d66"
    sha256 cellar: :any_skip_relocation, mojave:        "809cc928260685cd3517f73d38f9d4dbab62c41f07a2d3c2cf5259567bbf0671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ec85437a8cda720b5a001df1429a5c62017b3b0a6c3f211c9e8ab22b266eee8" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
