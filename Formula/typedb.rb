class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.3.1/typedb-all-mac-2.3.1.zip"
  sha256 "59a8e5e0c7395ddf8e9fa5278e5005da937816894942a282f602f9a71aa8c58c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be9d65ed56b574868f80b354cfceadee2f86fcba59f2aac7106fabd819895c1a" # linuxbrew-core
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server status")
  end
end
