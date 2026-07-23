class Tloc < Formula
  desc "Count source lines and LLM tokens in one pass"
  homepage "https://github.com/shaunobi/tloc"
  url "https://github.com/shaunobi/tloc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "372191e532b4fd26514720c41ee9960c0b3f7ff9c0d6cfffe3cd1675cdf16f1d"
  license "MIT"
  head "https://github.com/shaunobi/tloc.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/shaunobi/tloc/internal/buildinfo.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "tloc #{version}", shell_output("#{bin}/tloc --version")

    (testpath/"main.go").write <<~GO
      package main

      func main() {}
    GO

    output = shell_output("#{bin}/tloc --format json main.go")
    assert_match '"language": "Go"', output
    assert_match '"files": 1', output
  end
end
