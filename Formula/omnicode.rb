class Omnicode < Formula
  desc "Coding workspace with persistent terminal sessions"
  homepage "https://github.com/shiva3593/omnicode-releases"
  license all_of: ["MIT", "Apache-2.0"]

  depends_on "git"
  depends_on "node@24"
  depends_on "python@3.13"
  depends_on "rtk"

  uses_from_macos "lsof"

  on_macos do
    on_arm do
      url "https://github.com/shiva3593/omnicode-releases/releases/download/v0.1.0/omnicode-0.1.0-darwin-arm64.tar.gz"
      sha256 "151cbdb2388206db37b5122a89ce974f996199db90248eb25a262e37246f0338"
    end
    on_intel do
      url "https://github.com/shiva3593/omnicode-releases/releases/download/v0.1.0/omnicode-0.1.0-darwin-x64.tar.gz"
      sha256 "5acec162f52d61b92e4a87f6b7318f18069dee1cb28994ea49596a775f0b159a"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/shiva3593/omnicode-releases/releases/download/v0.1.0/omnicode-0.1.0-linux-arm64.tar.gz"
      sha256 "344c83c8179c38e2a951f21db91af7349f64d1767ca3d850953edf86d4fc79b3"
    end
    on_intel do
      url "https://github.com/shiva3593/omnicode-releases/releases/download/v0.1.0/omnicode-0.1.0-linux-x64.tar.gz"
      sha256 "c374a26c9aa41249e033c93fdaf9b8323de1321ccbafd33927841c8621853c66"
    end
  end

  # Homebrew relocation breaks frozen Python extensions.
  preserve_rpath

  def install
    prefix.install "bin", "libexec", "licenses", "components.json"
    paths = [
      formula_opt_bin("node@24").to_s,
      (formula_opt_libexec("python@3.13")/"bin").to_s,
      formula_opt_bin("python@3.13").to_s,
      formula_opt_bin("git").to_s,
      formula_opt_bin("rtk").to_s,
    ]
    paths << formula_opt_bin("lsof").to_s if OS.linux?
    (libexec/"paths.json").write JSON.generate({ search: paths, bin: opt_bin.to_s, libexec: opt_libexec.to_s })
  end

  def caveats
    "Run omnicode in a project folder. Edit ~/.config/omnicode; authenticate with omnicode --direct auth login."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnicode --version")
    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    assert_equal (testpath/"config/omnicode").to_s, shell_output("#{bin}/omnicode --config").strip
    assert_path_exists testpath/"config/omnicode/plugins/preset-agent-pool.mjs"
  end
end
