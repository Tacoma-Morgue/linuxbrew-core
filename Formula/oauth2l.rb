class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.2.2.tar.gz"
  sha256 "6bee262a59669be86e578190f4a7ce6f7b18d5082bd647de82c4a11257a91e83"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97afa02857ded76e58750c9258dcdf6696cd341f4ef5da3fcef1b506d4af5d60"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3997e4c2392de8d3ee2e7b4e6e6bdcdf6236e9d75fe1007afdf9b4aa4228913"
    sha256 cellar: :any_skip_relocation, catalina:      "a1364fb71118addb9dfd3ad4c30a4ffcc337eb5115c7ae40a7fe6825492116c3"
    sha256 cellar: :any_skip_relocation, mojave:        "5dfc5cfee1683e24ff6740c823920f629b13d834de40dc7832819e37428f9b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "543684c84116721a513ea30d43308f055c1d9d478e6780c925fbeac93db9234f" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end
