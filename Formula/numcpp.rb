class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/Version_2.5.0.tar.gz"
  sha256 "50a18611c2b2abda613e757ef6bd7d7efba761e0265cb16aa9700b45b0236d38"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98e4db2b2caa2f80ca5ad9c24d23065f69b3db75311be04ce22a633fc37cb8a2" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <NumCpp.hpp>

      int main() {
          nc::NdArray<int> a = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
          a = nc::diagonal(a);
          for (int i = 0; i < nc::shape(a).cols; ++i)
              std::cout << a[i] << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "1\n5\n9\n", shell_output("./test")
  end
end
