class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.6.1.tar.gz"
  sha256 "e8066b6bebda0aa52d5b7ea0b1d979a503f2435040f09f5dce0f354b8d10a4ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98ef8ae02722de52b759e6b07b332a5a9a81c2785d7a9c679b520ec06815295b"
    sha256 cellar: :any_skip_relocation, big_sur:       "673e990142d00733c9b8e9401ab9416598cb911ac5abac549e80fb485810a0e0"
    sha256 cellar: :any_skip_relocation, catalina:      "6e584933527b641a4658e7e7b40a92367566d73dde435ec998451251c2d13f93"
    sha256 cellar: :any_skip_relocation, mojave:        "056bf42e4b1c00e846ae6e1e84344f4e7368f59316108c860b6cb29fce4ad6d6"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
