class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with openexr.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.7.tar.gz"
  sha256 "36ecb2290cba6fc92b2ec9357f8dc0e364b4f9a90d727bf9a57c84760695272d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "972c5920255115ab63cc84c699e9cd032d120bbb85095f8a4d1f2865326ceaa8"
    sha256 cellar: :any,                 big_sur:       "71c8e6cedb938d2c5ec99fea9343805f293013b070ad561e2fa652194f84a59c"
    sha256 cellar: :any,                 catalina:      "e505a83ecb7ab3aee3f5cb38973612a559ec106a96d7142bc0f245556512a670"
    sha256 cellar: :any,                 mojave:        "a3416415f8a68fc12922080e36e24481833343d89a06aad74ad57034b2200eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da0eefc8bb7843f74af05c36641d23819f7cc117804cab57567ecaefb60e6197" # linuxbrew-core
  end

  keg_only "ilmbase conflicts with `openexr` and `imath`"

  # https://github.com/AcademySoftwareFoundation/openexr/pull/929
  deprecate! date: "2021-04-05", because: :unsupported

  depends_on "cmake" => :build

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      `ilmbase` has been replaced by `imath`. You may want to `brew uninstall ilmbase`
      or `brew unlink ilmbase` to prevent conflicts.
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~'EOS'
      #include <ImathRoots.h>
      #include <algorithm>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        double x[2] = {0.0, 0.0};
        int n = IMATH_NAMESPACE::solveQuadratic(1.0, 3.0, 2.0, x);

        if (x[0] > x[1])
          std::swap(x[0], x[1]);

        std::cout << n << ", " << x[0] << ", " << x[1] << "\n";
      }
    EOS
    system ENV.cxx, "-I#{include}/OpenEXR", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
