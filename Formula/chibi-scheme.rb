class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "https://github.com/ashinn/chibi-scheme"
  url "https://github.com/ashinn/chibi-scheme/archive/0.10.tar.gz"
  sha256 "ae1d2057138b7f438f01bfb1e072799105faeea1de0ab3cc10860adf373993b3"
  license "BSD-3-Clause"
  head "https://github.com/ashinn/chibi-scheme.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "18fc48f1b5623936fd24b7259b4bcb0e611a91ebe2354b2e1ca8b3dc99dd3eb6"
    sha256 big_sur:       "2547ea8be7276702a7db43cd70ca284d74fd7176d612e4b2bab2837343fd3736"
    sha256 catalina:      "38846d601710212a1e2769fd7415d176f0ee439798108ca022f86328fd23b42d"
    sha256 mojave:        "e24e63d2279cdc92dd95d61520c031b8c6ed1f57a3bbe5f7c971376c930112a1"
    sha256 x86_64_linux:  "1c757f47a0c5e062749b592fe721a3b16927d05a66458e891c870f52bc4f7e70" # linuxbrew-core
  end

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = `#{bin}/chibi-scheme -mchibi -e "(for-each write '(0 1 2 3 4 5 6 7 8 9))"`
    assert_equal "0123456789", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
