class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/f9/3e/14f27cbad8703a2bb3229bf94926582509c190d750afb3ac3d318551829b/pre_commit-2.14.1.tar.gz"
  sha256 "7977a3103927932d4823178cbe4719ab55bb336f42a9f3bb2776cff99007a117"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a2cd8d4a231f973aedc76fe8bcd27e44f478de246847848fdc783a52d59b7e9a"
    sha256 cellar: :any,                 big_sur:       "844c53119af074d8f385d94f53e1a25d7f991af4e9767834092919954edc8eec"
    sha256 cellar: :any,                 catalina:      "5ed43858c0bb46cb0a50b079adeae0d746d8db32dc58b48f9788de3781f6694d"
    sha256 cellar: :any,                 mojave:        "b27a0f03b9cbff195804c7673da048f5e68383c56f7b90788ef298aec0ee2967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc02552c3eb53c31259eca0631ee2748ea5ea686539f7c6b0b9f9f0ad8fd331e" # linuxbrew-core
  end

  depends_on "libyaml"
  depends_on "python@3.9"
  depends_on "six"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/c4/bf/d0d622b660d414a47dc7f0d303791a627663f554345b21250e39e7acb48b/cfgv-3.3.1.tar.gz"
    sha256 "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/45/97/15fdbef466e12c890553cebb1d8b1995375202e30e0c83a1e51061556143/distlib-0.3.2.zip"
    sha256 "106fef6dc37dd8c0e2c0a60d3fca3e77460a48907f335fa28420463a6f799736"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/60/7e/b8af97e380d57ff850d13b85473545a2229ec31d71ee04337610fe313e84/identify-2.2.13.tar.gz"
    sha256 "7bc6e829392bd017236531963d2d937d66fc27cadc643ac0aba2ce9f26157c79"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/75/8d/14c4ac588711f8de0dd02a11460ed72f48cab65a998994ca20f40c6e1a8f/nodeenv-1.6.0.tar.gz"
    sha256 "3ef13ff90291ba2a4a7a4ff9a979b63ffdd00a464dbe04acf0ea6471517a4c2b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/cb/ee4234464290e3dee893cf37d1adc87c24ade86ff6fc55f04a9bf9f1ec4f/platformdirs-2.2.0.tar.gz"
    sha256 "632daad3ab546bd8e6af0537d09805cec458dce201bccfe23012df73332e181e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/6d/89/9691b0d0521c069bd238585ccb7f4035b8393d843a50491270e7dae0209e/virtualenv-20.7.2.tar.gz"
    sha256 "9ef4e8ee4710826e98ff3075c9a4739e2cb1040de6a2a8d35db0055840dc96a0"
  end

  def install
    # Point hook shebang to virtualenv Python.
    # The global one also works - but may be keg-only.
    # A full path can also move around if we use versioned formulae.
    # Git hooks should only have to be installed once and never need changing.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'#!/usr/bin/env {py}'",
              "'#!#{opt_libexec}/bin/python3'"

    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "'INSTALL_PYTHON': sys.executable",
              "'INSTALL_PYTHON': '#{opt_libexec}/bin/python3'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    dirs_to_fix = [libexec/"lib/python#{xy}"]
    on_linux { dirs_to_fix << libexec/"bin" }
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
