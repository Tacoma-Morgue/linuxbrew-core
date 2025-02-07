class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.5.2.tar.gz"
  sha256 "f8b25ab86738864b1f2e3128e8badab581510fa8085ff5ca9bb980d317334c46"
  license "MIT"

  livecheck do
    url "https://github.com/nanomsg/nng.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "65e87ec5195f73dd28ac038232cfd97f726e39d6420ee3eb8b09043fb6bbaf74"
    sha256 cellar: :any,                 big_sur:       "4f8669a031bc81bcbee803c873ef1d97f2725d4a6fea722e5774b211edb7d6a5"
    sha256 cellar: :any,                 catalina:      "268c52493195599b0ab12c36ed1c3473ec170b10cad96b8a0117d3fdb3b17b50"
    sha256 cellar: :any,                 mojave:        "d2ef1609e6562912c88a0e8c5b9cb57058db7ef4f07d11b0ca881a114830d9a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea91ad4b5ac210903160da86f5c3d5482f8c1b77f3947b6455af9826af7df524" # linuxbrew-core
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", "-DNNG_ENABLE_DOC=ON", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end
