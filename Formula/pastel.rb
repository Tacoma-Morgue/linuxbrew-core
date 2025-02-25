class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.8.1.tar.gz"
  sha256 "e1afcd8035a4c1da7f6d0fc8d5fc703dee72baa77bd0588a67d3b606e70146cb"
  license "Apache-2.0"
  head "https://github.com/sharkdp/pastel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0acfb78bf2984605f33eff15d1514482f2f15920d3d93aa054f565beaa83dec"
    sha256 cellar: :any_skip_relocation, big_sur:       "d8732bd4a5f40bab0c9ac933227d75890ca70ab4f8641d6c7e6bd06327d76a22"
    sha256 cellar: :any_skip_relocation, catalina:      "1651b1afc8a63413679b2779317d3d0617edf72bdee29baf92b74dd865f1d146"
    sha256 cellar: :any_skip_relocation, mojave:        "a0e9bd8535cb95385d081c1bf657068adb5bf2cf4b2aaf00df5f7ad6cbaf512f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7d5916e318ae7b30b4e827951c68a83469b76d0273afe22e25373802a4bcf50" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
