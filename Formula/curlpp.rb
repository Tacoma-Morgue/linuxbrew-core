class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "https://www.curlpp.org/"
  url "https://github.com/jpbarrette/curlpp/archive/v0.8.1.tar.gz"
  sha256 "97e3819bdcffc3e4047b6ac57ca14e04af85380bd93afe314bee9dd5c7f46a0a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f727b823c94be8f12ab6ba0eb8ac326b19ac823f3313b9ff0a8ab43c1a21a4ec"
    sha256 cellar: :any,                 big_sur:       "1629615065defd61af8480c484f801e47e35c268defee303929003f7170d30ee"
    sha256 cellar: :any,                 catalina:      "d3ca609dae4e9f2038c6cd39ce0123fc8eb70bc235519079d526d529cedf0878"
    sha256 cellar: :any,                 mojave:        "206a7c8881489554e00c1a365b58a7c39922e5d66fca19b3f7296eb7472ef220"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    inreplace bin/"curlpp-config", %r{#{HOMEBREW_SHIMS_PATH}/[^/]+/super/#{ENV.cc}}, ENV.cc.to_s
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <curlpp/cURLpp.hpp>
      #include <curlpp/Easy.hpp>
      #include <curlpp/Options.hpp>
      #include <curlpp/Exception.hpp>

      int main() {
        try {
          curlpp::Cleanup myCleanup;
          curlpp::Easy myHandle;
          myHandle.setOpt(new curlpp::options::Url("https://google.com"));
          myHandle.perform();
        } catch (curlpp::RuntimeError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        } catch (curlpp::LogicError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        }

        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lcurlpp", "-lcurl"
    system "./test"
  end
end
