class PythonLauncher < Formula
  desc "Launch your Python interpreter the lazy/smart way"
  homepage "https://github.com/brettcannon/python-launcher"
  url "https://github.com/brettcannon/python-launcher/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "31e5a4e50e3db4506e8484db06f6503df1225f482b40a892ffb5131b4ec11a43"
  license "MIT"
  head "https://github.com/brettcannon/python-launcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8fb00eea4d01ceb13780d0a94687ecfa959012c20aefb0715283471c86b55bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "0060ddf0b4825662923bb18ea5ba45ed8de79d7adc343ca50e955ee56d371d32"
    sha256 cellar: :any_skip_relocation, catalina:      "91522804817f69fc416e17ef61c02f7d0727472e89148042afd4f52b4b65d926"
    sha256 cellar: :any_skip_relocation, mojave:        "2be4b95b5e33a6e1035bb19f07257941407351428b7a29efaa4a8429379be1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e595608af839cf8c50112ec315e6222b0809b5f7ab6f1543da48f993a5ea95a" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/man-page/py.1"
    fish_completion.install "completions/py.fish"
  end

  test do
    binary = testpath/"python3.6"
    binary.write("Fake Python 3.6 executable")
    with_env("PATH" => testpath) do
      assert_match("3.6 │ #{binary}", shell_output("#{bin}/py --list"))
    end
  end
end
