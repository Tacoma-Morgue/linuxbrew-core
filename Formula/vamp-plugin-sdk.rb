class VampPluginSdk < Formula
  desc "Audio processing plugin system sdk"
  homepage "https://www.vamp-plugins.org/"
  # curl fails to fetch upstream source, using Debian's instead
  url "https://deb.debian.org/debian/pool/main/v/vamp-plugin-sdk/vamp-plugin-sdk_2.10.0.orig.tar.gz"
  mirror "https://code.soundsoftware.ac.uk/attachments/download/2691/vamp-plugin-sdk-2.10.0.tar.gz"
  sha256 "aeaf3762a44b148cebb10cde82f577317ffc9df2720e5445c3df85f3739ff75f"
  head "https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk", using: :hg

  # code.soundsoftware.ac.uk has SSL certificate verification issues, so we're
  # using Debian in the interim time. If/when the `stable` URL returns to
  # code.soundsoftware.ac.uk, the previous `livecheck` block should be
  # reinstated: https://github.com/Homebrew/homebrew-core/pull/75104
  livecheck do
    url "https://deb.debian.org/debian/pool/main/v/vamp-plugin-sdk/"
    regex(/href=.*?vamp-plugin-sdk[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aa6184c469e855de77725477097a0c6998a04d4753bc852aa756123edaac446c"
    sha256 cellar: :any, big_sur:       "21e590739905e6794c11e4f7037adfa6fa83da4d7c2ab2b083c43563449d8a45"
    sha256 cellar: :any, catalina:      "b31926ceedbd7f79dc9783da8092b543c549d800705d9d8e8d8d0fd451d093de"
    sha256 cellar: :any, mojave:        "ee8d69d0b8c72e3e9ed1c79bfa7ca6650d10e36a2b110215b3d803f841ae2ec0"
    sha256 cellar: :any, high_sierra:   "834812edc745c782511f1397fb5e3e6995b9fd25b42426ec784cd5610dbc9eb4"
    sha256 cellar: :any, x86_64_linux:  "95b6cb12f447a52eb0c5104ca640898e0cd773e924ac998ccba7ffa91aac77d4" # linuxbrew-core
  end

  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "vamp-sdk/Plugin.h"
      #include <vamp-sdk/PluginAdapter.h>

      class MyPlugin : public Vamp::Plugin { };

      const VampPluginDescriptor *
      vampGetPluginDescriptor(unsigned int version, unsigned int index) { return NULL; }
    EOS

    flags = ["-Wl,-dylib"]
    on_linux { flags = ["-shared", "-fPIC"] }

    system ENV.cxx, "test.cpp", "-I#{include}", *flags, "-o", shared_library("test")
    assert_match "Usage:", shell_output("#{bin}/vamp-rdf-template-generator 2>&1", 2)

    cp "#{lib}/vamp/vamp-example-plugins.so", testpath/shared_library("vamp-example-plugins")
    ENV["VAMP_PATH"]=testpath
    assert_match "amplitudefollower", shell_output("#{bin}/vamp-simple-host -l")
  end
end
