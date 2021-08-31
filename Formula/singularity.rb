class Singularity < Formula
  desc "Application containers for Linux"
  homepage "https://singularity.hpcng.org"
  url "https://github.com/hpcng/singularity/releases/download/v3.8.1/singularity-3.8.1.tar.gz"
  sha256 "2648366fbc7e8fcba9d32f8f187ea149356c5f9083a57826d641359fa8415d9a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8579e2228ef36fe875618f5f16d99c417a57093762b99961c82d68789588f3c6" # linuxbrew-core
  end

  depends_on "go" => :build
  depends_on "openssl@1.1" => :build
  depends_on "libarchive"
  depends_on :linux
  depends_on "pkg-config"
  depends_on "squashfs"
  depends_on "util-linux" # for libuuid

  def install
    system "./mconfig", "--prefix=#{prefix}"
    cd "./builddir" do
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "There are 0 container file(s)", shell_output("#{bin}/singularity cache list")
  end
end
