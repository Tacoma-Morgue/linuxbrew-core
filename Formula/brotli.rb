class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.9.tar.gz"
  sha256 "f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46"
  license "MIT"
  head "https://github.com/google/brotli.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bcd00b6f423ec35f98aec55bc2c1cf433b6e70e915cdf04dd2c3a3707f1ce341"
    sha256 cellar: :any, big_sur:       "9d3009fd246d0f6cf9fd11d0a3bd388f6c043c75fa302decf0dd935163fb0f4b"
    sha256 cellar: :any, catalina:      "a382d95787cc2a5742a1d713f939bbc91ca6e097aee7f49f95cc111dca9fa9d7"
    sha256 cellar: :any, mojave:        "d121eaa3e670d5ad972514a4cc000326249694c8b9691013e28b8dd52b87410d"
    sha256 cellar: :any, high_sierra:   "126ecc002d37d167252743eb6ff5db19bb6aa4584ab3f731bd7876e438fc6dab"
    sha256 cellar: :any, x86_64_linux:  "079fe73a868cd0c2b8086d902a88d49ab03921a553ae860a6a3742e709c52c4d" # linuxbrew-core
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/brotli", "file.txt", "file.txt.br"
    system "#{bin}/brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
