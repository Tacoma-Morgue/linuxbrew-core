class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.16.0.tar.gz"
  sha256 "89f38b4ae1d09c65b2652a45de301ee92878153124ea98917fc22e26784505cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ad398d0aea06685de4c8fd4c41a54bc2f06c95076878bebe50434b0f1fdfe761"
    sha256 cellar: :any_skip_relocation, big_sur:       "4866362aad9eb5ec37928d53a23f9bbacfee9c124acce7afadb6af6569045532"
    sha256 cellar: :any_skip_relocation, catalina:      "7b757303e784867b12cc19db1be6c5f8ddeba831e1843a0349a7e5da2f5278a6"
    sha256 cellar: :any_skip_relocation, mojave:        "1b2a76a3b021d6d5b5cc14a532d5aac94734ce68c3f2b137d5ce037ed4c00062"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "bash")
    (bash_completion/"miniserve").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "zsh")
    (zsh_completion/"_miniserve").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "fish")
    (fish_completion/"miniserve.fish").write fish_output
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
