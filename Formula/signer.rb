class Signer < Formula
  desc "Sign PDFs with your ID card or USB token, with a visible stamp"
  homepage "https://github.com/alxrxs/signer"
  url "https://github.com/alxrxs/signer.git",
      tag:      "v1.0.0",
      revision: "40d0a0cff990d0f39a3790995b56979140e4d22e"
  license "AGPL-3.0-only"
  head "https://github.com/alxrxs/signer.git", branch: "main"

  depends_on macos: :golden_gate

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"

    app = buildpath/"Signer.app/Contents"
    (app/"MacOS").install ".build/release/Signer"
    app.install "Resources/Info.plist"
    (app/"Resources").install "Resources/AppIcon.icns"
    system "/usr/libexec/PlistBuddy", "-c",
           "Set :CFBundleShortVersionString #{version}", app/"Info.plist"
    system "codesign", "--force", "--sign", "-", buildpath/"Signer.app"
    prefix.install "Signer.app"
  end

  def caveats
    <<~EOS
      Link Signer into Applications and launch it:
        ln -sfn #{opt_prefix}/Signer.app /Applications/Signer.app
        open /Applications/Signer.app

      Signer signs with any card or token macOS can use. For the Romanian eID,
      also install rocei-connector.
    EOS
  end

  test do
    assert_path_exists prefix/"Signer.app/Contents/MacOS/Signer"
    system "codesign", "--verify", prefix/"Signer.app"
  end
end
