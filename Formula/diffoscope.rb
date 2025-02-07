class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/7a/40/1f85289a5070f8dd0858e69249e8de9d01c93252878d94ebab07af84f411/diffoscope-182.tar.gz"
  sha256 "5969c6f0060c5c553e5ae9fdff45fbd344f102ee8fb2c5673cf0c73999c50df4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af1e8597abd0d9e7c23809dc4660ecd80192233596ecc7e4e08e6d7f87a1485a"
    sha256 cellar: :any_skip_relocation, big_sur:       "098ea8bc8b378e8a8455fe2e84d5ed611c0f04465824cf8bf984d4386d8801a9"
    sha256 cellar: :any_skip_relocation, catalina:      "9e66f9134675372ac5c4efdb2fb1681a9ba8fafb2f67a59d5f3d44b24096e3ef"
    sha256 cellar: :any_skip_relocation, mojave:        "4dac1fe3c53fa32870108eb27a67837f794473c94a128aee518a5ab8653f42e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ff26b094b2a722859ded93eda018cd56386e9cd10beb2e5abbdad83706cfb9" # linuxbrew-core
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.9"

  # Use resources from diffoscope[cmdline]
  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/53/d5/bee2190570a2b4c372a022f16ebfc2313ff717a023f277f5d6f9ebf281a2/libarchive-c-3.1.tar.gz"
    sha256 "618a7ecfbfb58ca15e11e3138d4a636498da3b6bc212811af158298530fbb87e"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/3a/70/76b185393fecf78f81c12f9dc7b1df814df785f6acb545fc92b016e75a7e/python-magic-0.4.24.tar.gz"
    sha256 "de800df9fb50f8ec5974761054a708af6e4246b03b4bdaee993f948947b0ebcf"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
