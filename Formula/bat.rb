class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.18.2.tar.gz"
  sha256 "b176787e27da1f920b655bcd71b66c1569d241e2272bb9a4f6a64e6501c0cf2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5b14836bb035d63dfcf8342e648837812272f16c980d22f17f9f2529fa87bba"
    sha256 cellar: :any_skip_relocation, big_sur:       "566720155c70fee4a23c7ae07f7e785fde72396464c2b8c67dcf6b5c48f36579"
    sha256 cellar: :any_skip_relocation, catalina:      "add88b324d4caad18443fe084891f5fa131d9119769b2705663ce0ce28d23b3d"
    sha256 cellar: :any_skip_relocation, mojave:        "6d6f023db57e9f726c06d20e6cade443da3d63df80027dc4a8f7ac47b5f7a0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7441f566055bc8257a16d237417c053573a8e1d5a961dd5023a61af5e9b906f" # linuxbrew-core
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
