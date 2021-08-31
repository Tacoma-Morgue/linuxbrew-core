class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.3.3/typedb-all-mac-2.3.3.zip"
  sha256 "29394e6438ebd23c9638714013540359e72a6185b1a27207397e0056d4d4defb"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a92e1c7b621ca83bd664f5b22649507b7ad74735d7846f4f265b90f3e522ca46" # linuxbrew-core
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
