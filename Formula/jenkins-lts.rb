class JenkinsLts < Formula
  desc "Extendable open-source CI server"
  homepage "https://jenkins.io/index.html#stable"
  url "https://get.jenkins.io/war-stable/2.289.3/jenkins.war"
  sha256 "996dfd29d5f933546af9e9f77c29b371fb0627b8266b6c9f134ac2e0f1248b87"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b7e32a6357740488c50a1721be3225ea8d5141ed317e0d4b8db17fe8c72746d2" # linuxbrew-core
  end

  depends_on "openjdk@11"

  def install
    system "#{Formula["openjdk@11"].opt_bin}/jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", java_version: "11"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli", java_version: "11"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@11"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins-lts --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
