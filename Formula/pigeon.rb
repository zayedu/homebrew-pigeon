class Pigeon < Formula
  desc "Messaging between coding agents"
  homepage "https://github.com/zayedu/pigeon"
  url "https://github.com/zayedu/pigeon/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b6aba8c9015b8445550e8d48447d1a5ea3456b286e4f18e4669ee64c1a7425f3"
  license "MIT"

  depends_on "uv" => :build
  depends_on "python@3.13"

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec
    ENV["UV_LINK_MODE"] = "copy"
    system "uv", "sync", "--locked", "--no-dev", "--no-editable",
           "--no-python-downloads", "--python", Formula["python@3.13"].opt_bin/"python3.13"

    (bin/"pigeon").write_env_script libexec/"bin/pigeon",
                                    PIGEON_HOMEBREW_LAUNCHER: opt_bin/"pigeon"
  end

  test do
    assert_match "setup", shell_output("#{bin}/pigeon --help")
    assert_match "brew upgrade pigeon", shell_output("#{bin}/pigeon update")
    token = shell_output("#{bin}/pigeon relay enroll @test/agent --db #{testpath}/relay.sqlite3").strip
    assert_match(/\A[A-Za-z0-9_-]{43}\z/, token)
  end
end
