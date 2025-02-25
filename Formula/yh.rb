class Yh < Formula
  desc "YAML syntax highlighter to bring colours where only jq could"
  homepage "https://github.com/andreazorzetto/yh"
  url "https://github.com/andreazorzetto/yh/archive/v0.4.0.tar.gz"
  sha256 "78ef799c500c00164ea05aacafc5c34dccc565e364285f05636c920c2c356d73"
  license "Apache-2.0"
  head "https://github.com/andreazorzetto/yh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1c7d591013f9ba22f605f81f1f058c3377f4125ef1d0f990651e9cdd12805cdc"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8165967a843d90d96ed71a41b303b7b434cf855e1e456d428c694aeceeee737"
    sha256 cellar: :any_skip_relocation, catalina:      "1a2425d399a63df18758dfabf9d50da2559fb489c32bfb4462d7437f64fc0817"
    sha256 cellar: :any_skip_relocation, mojave:        "69f1ab9c740906f04924c780cb512ea26fa0c51bdf66be85c71c4cbaa9dc6ca1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "184eb9a41954f7a3d11f3065dfab42085a724c617ec635681e05784eeebe6329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb931efbbdf0b82803769d855550c979a6a7406813c5da5035de3fe0f3e42489" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_equal "\e[91mfoo\e[0m: \e[33mbar\e[0m\n", pipe_output("#{bin}/yh", "foo: bar")
  end
end
