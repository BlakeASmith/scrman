class Scrman < Formula
  desc "Script manager - Create and manage scripts in multiple languages"
  homepage "https://github.com/yourusername/scrman"
  url "https://github.com/yourusername/scrman/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "" # Will be filled when you create a release
  license "MIT"

  depends_on "ruby"

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.4.0.gem"
    sha256 "48255e1a74817fd8fc73fe20e80d1a9eb66e5e81b18e7a9fa6bd6e1fc7ca8e5f"
  end

  def install
    ENV["GEM_HOME"] = libexec
    
    # Install gem dependencies
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
             "--install-dir", libexec
    end
    
    # Install the library files
    libexec.install Dir["lib/*"]
    
    # Install the main executable to libexec
    (libexec/"scrman").install "bin/scrman"
    chmod 0755, libexec/"scrman"
    
    # Create wrapper script that sets up gem environment and load paths
    (bin/"scrman").write <<~EOS
      #!/bin/bash
      export GEM_HOME="#{libexec}"
      export GEM_PATH="#{libexec}"
      exec "#{Formula["ruby"].opt_bin}/ruby" -I"#{libexec}" "#{libexec}/scrman" "$@"
    EOS
    chmod 0755, bin/"scrman"
  end

  test do
    # Test that the command runs
    system "#{bin}/scrman", "help"
  end
end

