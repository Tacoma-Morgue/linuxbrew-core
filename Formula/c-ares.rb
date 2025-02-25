class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  # Check whether patch for `node.rb` can be removed at version bump
  url "https://c-ares.haxx.se/download/c-ares-1.17.2.tar.gz"
  sha256 "4803c844ce20ce510ef0eb83f8ea41fa24ecaae9d280c468c582d2bb25b3913d"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "faf4361fe875f4b4d9fa521c3aed53ae6ad1935a859dec0b7cfd4638c6841a82"
    sha256 cellar: :any,                 big_sur:       "999647263cf8819d6fd324ce9bf48ea5eaa94b34f7796c1fe3d772572f361459"
    sha256 cellar: :any,                 catalina:      "8cf15891ac55f5d9d7a28a5122e7c5ee6c9585c82643b029ee5c295bfd408209"
    sha256 cellar: :any,                 mojave:        "60adc74ad87d834ff201feef8a25c7e27b8ae8e3d1d09f71b08f41384cf994e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140ba2dd2dcbb041d411b37bca3c5e9c614fb066fc6a55299acf97f22a4628ba" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
