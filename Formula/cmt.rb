class Cmt < Formula
  desc "Write consistent git commit messages based on a custom template"
  homepage "https://github.com/smallhadroncollider/cmt"
  url "https://github.com/smallhadroncollider/cmt/archive/0.7.1.tar.gz"
  sha256 "364faaf5f44544f952b511be184a724e2011fba8f0f88fdfc05fef6985dd32f6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/smallhadroncollider/cmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2559564dc48042c6480d568cbb11da90489e7a1bcb6c8a86bfdc7845eb500a93"
    sha256 cellar: :any_skip_relocation, big_sur:       "22ba275206a22888107bf70ec7a9e53a74f1dc5daf66349a979dadfc174d99ff"
    sha256 cellar: :any_skip_relocation, catalina:      "350dea5c83e8b86cdba45f71fafcd0b8cf98c1a2e229a6d7ac51d8c7b679c38e"
    sha256 cellar: :any_skip_relocation, mojave:        "ee763541c32889f0840a7c143972ba194eeafdbbbfa38008a8dd2e851f2382b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2c199fc5c9d4304d7b9e065261242a5050c3331fc0df7d9e667d4dd220fdf5" # linuxbrew-core
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build

  def install
    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/".cmt").write <<~EOS
      {}

      Homebrew Test: ${*}
    EOS

    expected = <<~EOS
      *** Result ***

      Homebrew Test: Blah blah blah


      run: cmt --prev to commit
    EOS

    assert_match expected, shell_output("#{bin}/cmt --dry-run --no-color 'Blah blah blah'")
  end
end
