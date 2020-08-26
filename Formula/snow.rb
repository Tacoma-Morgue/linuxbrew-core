class Snow < Formula
  desc "Whitespace steganography: coded messages using whitespace"
  homepage "https://web.archive.org/web/20200701063014/www.darkside.com.au/snow/"
  # The upstream website seems to be rejecting curl connections.
  # Consistently returns "HTTP/1.1 406 Not Acceptable".
  url "https://dl.bintray.com/homebrew/mirror/snow-20130616.tar.gz"
  sha256 "c0b71aa74ed628d121f81b1cd4ae07c2842c41cfbdf639b50291fc527c213865"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9c662e59ae80a814b726baa86faa4e37e85f504e368579ede9e88254af4b8bde" => :catalina
    sha256 "bed2d75f7d4210b5bebd533b656bf0ee641f6aaa4665b6c914071d7d1a4a7f04" => :mojave
    sha256 "7db54bdc60bd0db33bc854e5b95a928183479d1f2d9ec65d69f36d3d8ccdae6a" => :high_sierra
    sha256 "3c975f8c77c450c084b8a468f5d51dd12acaa15dd93dbc440b4523b8dc130316" => :sierra
    sha256 "5121a5196c5ed20b7496a5190830bf2e49bdd18c3950fc6b1b8fabb239c9ef7c" => :el_capitan
    sha256 "f4e949f65f946916a5f0b018a75e741336fed9e6434f1802d906e003e9da6b65" => :yosemite
    sha256 "4d6bd4ca3de8ee330802495bdb04b0928afa21bb47a8fb1cde71d8a0c7919ada" => :mavericks
    sha256 "d61f0e62a8326ad9029d20a880804947efdd14a4d7dee36fd93dba24acf1d48f" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "snow"
    man1.install "snow.1"
  end

  test do
    touch "in.txt"
    touch "out.txt"
    system "#{bin}/snow", "-C", "-m", "'Secrets Abound Here'", "-p",
           "'hello world'", "in.txt", "out.txt"
    # The below should get the response 'Secrets Abound Here' when testing.
    system "#{bin}/snow", "-C", "-p", "'hello world'", "out.txt"
  end
end
