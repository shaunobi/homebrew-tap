class Tloc < Formula
  desc "Count source lines and LLM tokens in one pass"
  homepage "https://github.com/shaunobi/tloc"
  url "https://github.com/shaunobi/tloc/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "90dfafe6883aa52171b9cfac5ff32dc8c9c346114e23a4961bc4c2527bfe287d"
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
