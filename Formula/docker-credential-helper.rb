class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.4.tar.gz"
  sha256 "b97d27cefb2de7a18079aad31c9aef8e3b8a38313182b73aaf8b83701275ac83"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca1327a8e612c4e5de20796bffbe54cb4aaa3b73b5a0d659e9da0bd701a4bed6"
    sha256 cellar: :any_skip_relocation, big_sur:       "b86ee5413d74bb4e52c8c7cd056168b421096acb2a20be4ed8fc8192851b2e4a"
    sha256 cellar: :any_skip_relocation, catalina:      "b0d84bdcdeb21c6a19cd765cd09fe9646e7c50370c61f5f4460e30d730128bbe"
    sha256 cellar: :any_skip_relocation, mojave:        "b9949fc061dea2f7fcf6e54039203d133ffe3f00706b16e43623f90bb57331d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5fcb0d51e2f88f96d26d2ea012403c1882c51ff85bff4828b377b1e73f1530c" # linuxbrew-core
  end

  depends_on "go" => :build
  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/docker/docker-credential-helpers"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      on_macos do
        system "make", "vet_osx"
        system "make", "osxkeychain"
        bin.install "bin/docker-credential-osxkeychain"
      end
      on_linux do
        system "make", "vet_linux"
        system "make", "pass"
        system "make", "secretservice"
        bin.install "bin/docker-credential-pass"
        bin.install "bin/docker-credential-secretservice"
      end
      prefix.install_metafiles
    end
  end

  test do
    on_macos do
      # A more complex test isn't possible as this tool operates using the macOS
      # user keychain (incompatible with CI).
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match %r{^Usage: .*/docker-credential-osxkeychain.*}, run_output
    end
    on_linux do
      run_output = shell_output("#{bin}/docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Error from list function in secretservice_linux.c", run_output
    end
  end
end
