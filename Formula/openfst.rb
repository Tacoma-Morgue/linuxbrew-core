class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "http://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "http://openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.1.tar.gz"
  sha256 "24fb53b72bb687e3fa8ee96c72a31ff2920d99b980a0a8f61dda426fca6713f0"
  license "Apache-2.0"

  livecheck do
    url "http://www.openfst.org/twiki/bin/view/FST/FstDownload"
    regex(/href=.*?openfst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6133234e79a10929c05657d79c9f47e8e646b36cf7f023ab9dd8b3151dec7f34"
    sha256 cellar: :any,                 big_sur:       "d5139b2d98c091cb1d3b5215392b9c84ee94e6d51e0a2a1dad6a4ff05b9dc2c9"
    sha256 cellar: :any,                 catalina:      "7aea4b496aac30803d9cdb99f90e30ba0b44b240a822f7b9a25df963f845f57b"
    sha256 cellar: :any,                 mojave:        "1e4d6b330797e513315266073af2647d08b1e5a123d11fc165ace77cd2de43e6"
  end

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsts",
                          "--enable-compress",
                          "--enable-grm",
                          "--enable-special"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"text.fst").write <<~EOS
      0 1 a x .5
      0 1 b y 1.5
      1 2 c z 2.5
      2 3.5
    EOS

    (testpath/"isyms.txt").write <<~EOS
      <eps> 0
      a 1
      b 2
      c 3
    EOS

    (testpath/"osyms.txt").write <<~EOS
      <eps> 0
      x 1
      y 2
      z 3
    EOS

    system bin/"fstcompile", "--isymbols=isyms.txt", "--osymbols=osyms.txt", "text.fst", "binary.fst"
    assert_predicate testpath/"binary.fst", :exist?
  end
end
