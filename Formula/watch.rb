class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      tag:      "v3.3.17",
      revision: "19a508ea121c0c4ac6d0224575a036de745eaaf8"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "45b90fbbda918d2c87ef6ccc29f1d931cbd0a490f2b1d599444591aae04a3cb0"
    sha256 cellar: :any,                 big_sur:       "251b920890874ad798cf01c4c52564c720f785ce8184ae41181654b8f65e592b"
    sha256 cellar: :any,                 catalina:      "05698a04a502ac32c97e0de0d9f00ac7c7450afd5d42b85d8ce1cd55d010fff3"
    sha256 cellar: :any,                 mojave:        "d2ce790ff9e073d04615051cd94dce4e06d37993de21894a64d4a23b7dfe5ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a290ddebeefec75890fa104a24756721fb5c623a756b6de7c36bd4a9e69feecc" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls",
                          "--enable-watch8bit"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
