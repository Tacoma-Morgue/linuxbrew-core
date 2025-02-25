class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.9.tar.gz"
  sha256 "caa4b3dd314e065c6f387b2713f7603673e39a8a0b1a76f96ef6c9a5b845da0f"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "5e915e427db3117320aff459d67438ac7bf94cf3e37291ca02a1d6b83f2fa827"
    sha256 cellar: :any,                 big_sur:       "9c86c4043d4ebadd47e6ba606b80dcf0611f302dd11d6f8f56b9c4c1f1d3bfe9"
    sha256 cellar: :any,                 catalina:      "42a044324786df52bcb3334eb3c07b3c3ac65414af72c17c73ccb0fb081507ab"
    sha256 cellar: :any,                 mojave:        "fc5d9762d710f500978ac0d09b0fbf6fcf3745c4b018313fe9d3ae5679e1f37e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libsodium"

  uses_from_macos "expect" => :test

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "Hello World!"
    (testpath/"keygen.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/minisign -G
      expect -exact "Please enter a password to protect the secret key."
      expect -exact "\n"
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect -exact "\r
      Password (one more time): "
      send -- "Homebrew\n"
      expect eof
    EOS

    system "expect", "-f", "keygen.exp"
    assert_predicate testpath/"minisign.pub", :exist?
    assert_predicate testpath/".minisign/minisign.key", :exist?

    (testpath/"signing.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/minisign -Sm homebrew.txt
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect eof
    EOS

    system "expect", "-f", "signing.exp"
    assert_predicate testpath/"homebrew.txt.minisig", :exist?
  end
end
