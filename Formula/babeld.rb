class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.10.tar.gz"
  sha256 "a5f54a08322640e97399bf4d1411a34319e6e277fbb6fc4966f38a17d72a8dea"
  license "MIT"
  head "https://github.com/jech/babeld.git", branch: "master"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84bd566d6b25d9b9a5f76c444c555fba9349457f09736d033903f9fbe576babf"
    sha256 cellar: :any_skip_relocation, big_sur:       "63a4e1edb9625b5f3e11df84a840979330b0bd3af8d77dec25fe09e92698719f"
    sha256 cellar: :any_skip_relocation, catalina:      "b6906565df2c7862dd7979ef3599414bc59f0b78b05b0e3a9dbf411ab29fad83"
    sha256 cellar: :any_skip_relocation, mojave:        "a59602b1643b95845ab9d1b6ecd68d1231ee825ac68fadb577e93d85b9b99ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47467d998e46d7e837d4b226edf4c22c29a8be28973dd56d7ffebffeb4e5437d" # linuxbrew-core
  end

  def install
    on_macos do
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    end
    on_linux do
      system "make"
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    assert_match "kernel_setup failed", (testpath/"test.log").read
  end
end
