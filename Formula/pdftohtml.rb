class Pdftohtml < Formula
  desc "Utility which converts PDF files into HTML and XML formats"
  homepage "https://pdftohtml.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz"
  sha256 "277ec1c75231b0073a458b1bfa2f98b7a115f5565e53494822ec7f0bcd8d4655"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/pdftohtml[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61d5a75c1351339a1e1cee32c585172bc638503e4fea57232532daae41bbb2e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "17a699cdc73b7674f537adec7ea8ad696374921c84a52dfaacaa05882f5696da"
    sha256 cellar: :any_skip_relocation, catalina:      "d8a6e5bb1d84ee766898543d77307b4a9a6e6f826ebe9cc48ce6db8bb24c8923"
    sha256 cellar: :any_skip_relocation, mojave:        "c49245634c48c7c24501cfb848a98e4b6a281ff0cf89235bb7a7ce09619e66ad"
    sha256 cellar: :any_skip_relocation, high_sierra:   "200be428031e013f58b792b092b56e74743d6362d747b0c883bb95269d7a5e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9143a7594d0cfb28d97e49ffdf477649837f481179b74067f997d0a9fe9b14a" # linuxbrew-core
  end

  conflicts_with "pdf2image", "poppler", "xpdf",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "make"
    bin.install "src/pdftohtml"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/pdftohtml -stdout #{test_fixtures("test.pdf")}")
  end
end
