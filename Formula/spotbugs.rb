class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https://spotbugs.github.io/"
  url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/4.4.0/spotbugs-4.4.0.tgz"
  sha256 "126b952cf248c92fbb7ba07462a71b3400bd1726fed96e179d8a50edd3e40745"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "76f50e908537a3be7b78fd55893ea1f568e4a390c513b02529ac50934e6ea40e" # linuxbrew-core
  end

  head do
    url "https://github.com/spotbugs/spotbugs.git"

    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  conflicts_with "fb-client", because: "both install a `fb` binary"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    if build.head?
      system "gradle", "build"
      system "gradle", "installDist"
      libexec.install Dir["spotbugs/build/install/spotbugs/*"]
    else
      libexec.install Dir["*"]
      chmod 0755, "#{libexec}/bin/spotbugs"
    end
    (bin/"spotbugs").write_env_script "#{libexec}/bin/spotbugs", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      public class HelloWorld {
        private double[] myList;
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
        public double[] getList() {
          return myList;
        }
      }
    EOS
    system "#{Formula["openjdk"].bin}/javac", "HelloWorld.java"
    system "#{Formula["openjdk"].bin}/jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    output = shell_output("#{bin}/spotbugs -textui HelloWorld.jar")
    assert_match(/M V EI.*\nM C UwF.*\n/, output)
  end
end
