class CfTool < Formula
  desc "Command-line tool for Codeforces contests"
  homepage "https://github.com/xalanq/cf-tool"
  url "https://github.com/xalanq/cf-tool/archive/v1.0.0.tar.gz"
  sha256 "6671392df969e7decf9bf6b89a43a93c2bde978e005e99ddb7fd84b0c513df9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "cfa1c30932a9016c5f8ab0a5a266d5c3bdafc2910cb5259b2c2c7a86e83b3d98"
    sha256 cellar: :any_skip_relocation, catalina:     "3369b5efe4c26d786fa8a54d4ca208c11dc89850565adaf6a1c922f4f16d2a3f"
    sha256 cellar: :any_skip_relocation, mojave:       "4344edd7a9160d7113d135c574146f6ca5bedfded9e8633b02642276999e6dbe"
    sha256 cellar: :any_skip_relocation, high_sierra:  "a3497993ba1bae8cda20da28d5fb7ea8687ba0e50a23d5f6687d515457c4a00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a09556afd41a886a94200257be4a8e24647b25d2c0fde35cf7d5426bde6fe30f" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/xalanq/cf-tool").install buildpath.children
    cd "src/github.com/xalanq/cf-tool" do
      system "go", "build", "-o", "cf", "-trimpath", "-ldflags", "-s -w", "cf.go"
      bin.install "cf"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/cf", "list", "1256"
  end
end
