class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.2.0.tar.gz"
  sha256 "099a6293d5b47dad984db3d73063942b6e7e3b7ab65265d135a2f328e53b5753"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_big_sur: "24436faa98e02fab372bd21f259f7887a3625bdb65af748468093f82decf260a"
    sha256 big_sur:       "e292812ed36b3fe83dee5d078bc422b6229f8c5c9444ed29fe673db8f59cd40e"
    sha256 catalina:      "5b993514ce5131ad43f3945e3867c787e5b595f946b7d372be14b246aef9aa3b"
    sha256 mojave:        "098f4cc393cc05652042d7c2218d5c2c07d36f125a73d8982737e09433b34d2e"
    sha256 x86_64_linux:  "f7be8612affd4c16510f052ec478dbf0e5ca0224c04411b8f8b237c607a66686" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=ON",
                            "-DLCB_BUILD_LIBUV=ON"
      system "make", "install"
    end
  end

  test do
    assert_match "LCB_ERR_CONNECTION_REFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
