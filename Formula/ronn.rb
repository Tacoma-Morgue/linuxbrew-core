class Ronn < Formula
  desc "Builds manuals - the opposite of roff"
  homepage "https://rtomayko.github.io/ronn/"
  url "https://github.com/rtomayko/ronn/archive/0.7.3.tar.gz"
  sha256 "808aa6668f636ce03abba99c53c2005cef559a5099f6b40bf2c7aad8e273acb4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_big_sur: "5c1633f7c2bbed5e9570abdfeab0e09267d5950cc1dd1e1407390e78f7061c99"
    sha256                               big_sur:       "039c6b58bcb2a23599731b0616f86367f599a18ca1e9ac6aabad00c759d51e1c"
    sha256                               catalina:      "99c4f8018ba5bbc2c5e3c38e1015550b2917a287f4a4c8be49e8ee363f70e3ae"
    sha256                               mojave:        "1544009e832681a6a93e8f7f3edd13df690d52f7e8c16449b79820895bb257b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfd60e5550c58104384fddf72ff29d467cd721e9b84dfea410720b1c19e160b" # linuxbrew-core
  end

  depends_on "groff" => :test

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "ronn.gemspec"
    system "gem", "install", "ronn-#{version}.gem"
    bin.install libexec/"bin/ronn"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "man/ronn.1"
    man7.install "man/ronn-format.7"
  end

  test do
    (testpath/"test.ronn").write <<~EOS
      simple(7) -- a simple ronn example
      ==================================

      This document is created by ronn.
    EOS
    system bin/"ronn", "--date", "1970-01-01", "test.ronn"
    assert_equal <<~EOS, shell_output("groff -t -man -Tascii test.7 | col -bx")
      SIMPLE(7)                                                            SIMPLE(7)



      1mNAME0m
             1msimple 22m- a simple ronn example

             This document is created by ronn.



                                       January 1970                        SIMPLE(7)
    EOS
  end
end
