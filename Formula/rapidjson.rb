class Rapidjson < Formula
  desc "JSON parser/generator for C++ with SAX and DOM style APIs"
  homepage "https://miloyip.github.io/rapidjson/"
  url "https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz"
  sha256 "bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e"
  license "MIT"
  head "https://github.com/miloyip/rapidjson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07acf5e89f30f9db3b69ad953bf4490ed02f6e5eec9d5f84987962132373aa6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab0ca0d82021a22ca8d2e5667f13efc16ea08e18c50e5efadaa1e07ea72f9a31"
    sha256 cellar: :any_skip_relocation, catalina:      "5d8915ade32a25a3c2a973de3536285b2c3d8badd57478c475a9e3eac0f47dc6"
    sha256 cellar: :any_skip_relocation, mojave:        "9871eeed683c9cb7198c00c87225dd44fc4b40dfa20be2301a63c034ecc221e2"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4f40efdbe80e8060d03cfcffdcb2e51d3e4d3924272c96825c6966e00a1ee2e2"
    sha256 cellar: :any_skip_relocation, sierra:        "9fbe96e76e21457931a5e2fff343833b84941e2387ab02212946ad71665c3f6f"
    sha256 cellar: :any_skip_relocation, el_capitan:    "d0b949a9bd043535e2ff3e032b45b26de0083d319bc094db7ccc1edfea6cbdb3"
    sha256 cellar: :any_skip_relocation, yosemite:      "252ec61e7d5cba129a888bb566d4f2b61bd1bd2886de637f48afa638e6764007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f086510b72c1c87960df0e6ad707afb46e0d59e6b8298209f20a1ec3d0a2007f" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  conflicts_with "mesos", because: "mesos installs a copy of rapidjson headers"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system ENV.cxx, "#{share}/doc/RapidJSON/examples/capitalize/capitalize.cpp", "-o", "capitalize"
    assert_equal '{"A":"B"}', pipe_output("./capitalize", '{"a":"b"}')
  end
end
