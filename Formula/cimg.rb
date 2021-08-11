class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_2.9.8.zip"
  sha256 "1bbb2091498a46cff0e8aa75cb77be80fef0d6b9b386eb021c9515895f13b171"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  def install
    include.install "CImg.h"
    prefix.install "Licence_CeCILL-C_V1-en.txt", "Licence_CeCILL_V2-en.txt"
    pkgshare.install "examples", "plugins"
  end

  test do
    cp_r pkgshare/"examples", testpath
    cp_r pkgshare/"plugins", testpath
    cp include/"CImg.h", testpath
    system "make", "-C", "examples", "image2ascii"
    system "examples/image2ascii"
  end
end
