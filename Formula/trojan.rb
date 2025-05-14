class Trojan < Formula
  desc "An unidentifiable mechanism that helps you bypass GFW."
  homepage "https://trojan-gfw.github.io/trojan/"
  url "https://github.com/trojan-gfw/trojan/archive/v1.16.0.tar.gz"
  head "https://github.com/trojan-gfw/trojan.git", branch: "master"
  sha256 "86cdb2685bb03a63b62ce06545c41189952f1ec4a0cd9147450312ed70956cbc"
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "python" => :test
  depends_on "coreutils" => :test

  def install
    system "sed", "-i", "", "s/server\\.json/client.json/", "CMakeLists.txt"

    cmake_args = %w[-DENABLE_MYSQL=OFF]
    if OS.mac?
      cmake_args << "-DAPPLE=ON"
    end

    system "cmake", ".", *std_cmake_args, *cmake_args
    system "make", "install"
  end

  service do
    run ["#{opt_bin}/trojan", "-c", "#{etc}/trojan/config.json"]
    keep_alive successful_exit: true
    log_path "#{var}/log/trojan.log"
    error_log_path "#{var}/log/trojan.log"
  end
end
