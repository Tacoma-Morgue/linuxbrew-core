class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.11.0",
      revision: "01f52892191cfbaf9fcc233746e473bfa1129927"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "38101101de8fb48919a6bf20298e4ad564a9d3ebecba753b78eb45dec32dfdf4"
    sha256 cellar: :any_skip_relocation, big_sur:       "81112601411c6e7418fccf84454c8af7b1aef1a9ef4084304684832af56d7773"
    sha256 cellar: :any_skip_relocation, catalina:      "3aeb07bfe9f0ea7af5d1fab4a954358c5d99975e25950c046a64d4931cb98643"
    sha256 cellar: :any_skip_relocation, mojave:        "729305296d59e130a4eb60b72ed81a2bb3d17711bf4ced566a17e437c79accd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "709d8d657e9c2e9d361989d99b19618d8304cb3d3926e4738e8c6c5efb61e007" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
