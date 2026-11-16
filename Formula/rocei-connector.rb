class RoceiConnector < Formula
  desc "Native macOS driver for the Romanian electronic ID card (CEI)"
  homepage "https://github.com/alxrxs/ROCEIConnector"
  url "https://github.com/alxrxs/ROCEIConnector.git",
      tag:      "v1.0.0",
      revision: "4f570e3040b9e75ce78a22ac89d24bb79d1f53f6"
  license "AGPL-3.0-only"
  head "https://github.com/alxrxs/ROCEIConnector.git", branch: "main"

  depends_on macos: :golden_gate

  def install
    ENV["CODESIGN_IDENTITY"] = "-"
    ENV["VERSION"] = version.to_s
    system "./build.sh"
    prefix.install "build/RO CEI Connector.app"
  end

  def caveats
    <<~EOS
      Link RO CEI Connector into Applications and open it once, which registers
      the card driver with macOS:
        ln -sfn "#{opt_prefix}/RO CEI Connector.app" "/Applications/RO CEI Connector.app"
        open "/Applications/RO CEI Connector.app"

      After `brew upgrade`, open it once again. Then insert the card; check with
        security list-smartcards
    EOS
  end

  test do
    app = prefix/"RO CEI Connector.app"
    assert_path_exists app/"Contents/PlugIns/ROCEIExtension.appex"
    system "codesign", "--verify", "--deep", app
  end
end
