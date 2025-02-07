class Libstatgrab < Formula
  desc "Provides cross-platform access to statistics about the system"
  homepage "https://www.i-scream.org/libstatgrab/"
  url "https://ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.92.1.tar.gz"
  mirror "https://www.mirrorservice.org/pub/i-scream/libstatgrab/libstatgrab-0.92.1.tar.gz"
  sha256 "5688aa4a685547d7174a8a373ea9d8ee927e766e3cc302bdee34523c2c5d6c11"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ce70f4a494445f8afde960c4ceea838e48b98fcf4c4d9513f705afae83193433"
    sha256 cellar: :any,                 big_sur:       "08aba9012402bf7611ddc2fb0f6e0dfcb31c97ce067dd83d6ae73830b5d30aeb"
    sha256 cellar: :any,                 catalina:      "802d07a3f0948bf0f3a60bb174b1ee56e028b4b24f9eb121e9f90e5926e689c0"
    sha256 cellar: :any,                 mojave:        "8ce7e1320ee7e3d10764ace6801eecb28cac49dadef648de79258e1d254da06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8984abcb585701a695fedbebd0c13cd61b08b95240c22485c75e2aac1575c57a" # linuxbrew-core
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/statgrab"
  end
end
