class Libmemcached < Formula
  desc "C and C++ client library to the memcached server"
  homepage "https://libmemcached.org/"
  url "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
  sha256 "e22c0bb032fde08f53de9ffbc5a128233041d9f33b5de022c0978a2149885f82"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "513613e8b8e42dc519ed5c1f4a4dea775007bc16bf2865e091b1a84d6408459a"
    sha256 cellar: :any, big_sur:       "a478771c8936747ea8cbc56a2a7d38ed7db959de035b090710dadc30d187fc91"
    sha256 cellar: :any, catalina:      "24c7d9597b28d79f50f86777aa506b1955737d9e3298e1d79c3ad95b74fb66f8"
    sha256 cellar: :any, mojave:        "203121f43d48b8245a1bb963eded3d56aa44ec921176b9819004e62b12acdc48"
    sha256 cellar: :any, high_sierra:   "59032bd9e04061aaa7ffafdda12e66535f2e73da25571da0cede2dc21bc62f22"
    sha256 cellar: :any, x86_64_linux:  "0b7430e9e2d048e10580161acd2e3138800d71a1e200fd937645eb8d97443a13" # linuxbrew-core
  end

  depends_on "memcached" => :test

  # https://bugs.launchpad.net/libmemcached/+bug/1245562
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/60f3532/libmemcached/1.0.18.patch"
    sha256 "592f10fac729bd2a2b79df26086185d6e08f8667cb40153407c08d4478db89fb"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <string.h>

      #include <libmemcached-1.0/memcached.h>

      int main(int argc, char **argv) {
          char conf[50] = "--SERVER=127.0.0.1:";
          strncat(conf, argv[1], 5);
          memcached_st *memc = memcached(conf, strlen(conf));
          assert(memc != NULL);

          // Add a value.
          const char *key = "key";
          const char *val = "val";
          assert(memcached_add(memc, key, strlen(key), val, strlen(val),
                               (time_t)0, (uint32_t)0) == MEMCACHED_SUCCESS);

          // Fetch and check the added value.
          size_t return_val_len;
          uint32_t return_flags;
          memcached_return_t error;
          char *return_val = memcached_get(memc, key, strlen(key),
                                           &return_val_len, &return_flags, &error);
          assert(return_val != NULL);
          assert(error == MEMCACHED_SUCCESS);
          assert(return_val_len == strlen(val));
          assert(strncmp(return_val, val, return_val_len) == 0);
          assert(return_flags == 0);
          free(return_val);

          memcached_free(memc);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmemcached", "-o", "test"

    memcached = Formula["memcached"].bin/"memcached"
    port = free_port
    io = IO.popen("#{memcached} -l 127.0.0.1 -p #{port}")
    sleep 1
    system "./test", port
    Process.kill "TERM", io.pid
  end
end
