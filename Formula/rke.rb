class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.0.tar.gz"
  sha256 "4701ac241725df714b90261263be8358462e9481fd560401882e20a8e9856eff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c53caa211010815010bb47b1977abf49b8a5eacb69be4b462d9697a46872e78c"
    sha256 cellar: :any_skip_relocation, big_sur:       "87ed956a931ce0a769403b09d5ec03b8f61a5d9f36505f3ec74bd5ee9008a2a2"
    sha256 cellar: :any_skip_relocation, catalina:      "95ed89cef7ef677c5e9a887050f143708114ab4809cb033a0076350e37db5cf0"
    sha256 cellar: :any_skip_relocation, mojave:        "af86f734d885e4df3f7c4a0b5c802657dca05b95c29d8197d47ff383c13ccf21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
