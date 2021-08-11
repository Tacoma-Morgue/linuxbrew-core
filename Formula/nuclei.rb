class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.4.3.tar.gz"
  sha256 "71e9ec1892e56739a04ade2a58dc86d625157a85842685964e0e0ed215e8b05d"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c4fa1564d73962d0097e912f9ee536964d6e9300cd8ef391e9e0b4e130fbffa"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcfb63e6cfc04cd4aadf7f7bc66d1d216f7f5405ded3aa7b2464fdc6381db257"
    sha256 cellar: :any_skip_relocation, catalina:      "76ed872f94601a58450b880ca27b290c43a43ab5b5d194927a7b1e0eedef8cfc"
    sha256 cellar: :any_skip_relocation, mojave:        "9f0ae33189169d727f7f45cb19b687dfe29afb8c605f2c9cd0b5b565de0e66c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8af0df46c9146e1199f0170c77f19eefc9da81f7e490b81c66e5db51c3ef43c" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args, "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: \"{{FQDN}}\"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - \"IN\tA\"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
