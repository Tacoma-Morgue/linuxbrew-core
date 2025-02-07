class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.8.0.tar.gz"
  sha256 "d1f40e47574c65700f0ec98bf66729378efabe3c72bc0cda795037498541c10d"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1529dd1b1c1f9aa0ec59758868af1020a5e880bcde1fb886ba20077fc6bf279"
    sha256 cellar: :any_skip_relocation, big_sur:       "d82d41c9039868bd86a5a3bff42307fea589ffcbc5629d95238e579dec65cbc2"
    sha256 cellar: :any_skip_relocation, catalina:      "741c2079361cdb5881a60684190bc4aa98ff9cc6f8d29aa46880e809ac1b06c3"
    sha256 cellar: :any_skip_relocation, mojave:        "f389012b8211b70af4fa7d2eed8db8ad399ef2bdc98e286fb57a4b1beb93dfe4"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9c3beb8d8db3b372e4d2fd07d99a553fde6ff53824c6cfec82c3db41e212bc5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db7f26f75d26566d62caebd676bef134040fbf97d3129d63594b59bb28eef3ba" # linuxbrew-core
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write shell_output("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end
