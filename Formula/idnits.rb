class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.17.00.tgz"
  sha256 "986ff822cdd6f4bf1bca943dcd22ed5804c6e9725063401317f291d9f5481725"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?idnits[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  resource "test" do
    url "https://tools.ietf.org/id/draft-tian-frr-alt-shortest-path-01.txt"
    sha256 "dd20ac54e5e864cfd426c7fbbbd7a1c200eeff5b7b4538ba3a929d9895f01b76"
  end

  def install
    bin.install "idnits"
  end

  test do
    resource("test").stage do
      system "#{bin}/idnits", "draft-tian-frr-alt-shortest-path-01.txt"
    end
  end
end
