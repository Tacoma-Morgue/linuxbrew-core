class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.59.1/meson-0.59.1.tar.gz"
  sha256 "db586a451650d46bbe10984a87b79d9bcdc1caebf38d8e189f8848f8d502356d"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18e2e5fedef3e9853ab12b8e9f0e0b486b8d53837346f8025bf35ff2e58f308e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5a6b1422db1ea301dd5da6cbe25731baca4e030d939ce688f7c7cee1a4b55e8"
    sha256 cellar: :any_skip_relocation, catalina:      "c5a6b1422db1ea301dd5da6cbe25731baca4e030d939ce688f7c7cee1a4b55e8"
    sha256 cellar: :any_skip_relocation, mojave:        "c5a6b1422db1ea301dd5da6cbe25731baca4e030d939ce688f7c7cee1a4b55e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e2e5fedef3e9853ab12b8e9f0e0b486b8d53837346f8025bf35ff2e58f308e" # linuxbrew-core
  end

  depends_on "ninja"
  depends_on "python@3.9"

  def install
    version = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
