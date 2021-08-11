class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.13.4/apache-geode-1.13.4.tgz"
  mirror "https://archive.apache.org/dist/geode/1.13.4/apache-geode-1.13.4.tgz"
  mirror "https://downloads.apache.org/geode/1.13.4/apache-geode-1.13.4.tgz"
  sha256 "2a3eea3a45444a2e5082e0e79411cd8e76dac59fd7ac88e8165225f5569ee4df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1d97207b9414b5a96c352612ebe7d45a0a9014caa673a63b4f060eee418a3337" # linuxbrew-core
  end

  depends_on "openjdk@11"

  def install
    rm_f "bin/gfsh.bat"
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    (bin/"gfsh").write_env_script libexec/"bin/gfsh", Language::Java.java_home_env("11")
  end

  test do
    flags = "--dir #{testpath} --name=geode_locator_brew_test"
    output = shell_output("#{bin}/gfsh start locator #{flags}")
    assert_match "Cluster configuration service is up and running", output
  ensure
    quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
  end
end
