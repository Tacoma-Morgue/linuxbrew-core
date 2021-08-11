require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.5.0.tgz"
  sha256 "245768d2698bfe2bf8f38128b4d5f3fd5fe8988d95aaaebe71237143379f1d99"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "938206cf679491a446d17b648565287c3df691a5e6e3ece8a3a9836758e79fb5"
    sha256 cellar: :any_skip_relocation, big_sur:       "92760d15e35555fc2c1279b1c123d217d706c460158a7ee5f5c5d1b650717098"
    sha256 cellar: :any_skip_relocation, catalina:      "92760d15e35555fc2c1279b1c123d217d706c460158a7ee5f5c5d1b650717098"
    sha256 cellar: :any_skip_relocation, mojave:        "92760d15e35555fc2c1279b1c123d217d706c460158a7ee5f5c5d1b650717098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95ad73835ebef77205af6e80401e5ea171cd940e4e801aacd30a08918419a771" # linuxbrew-core
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
