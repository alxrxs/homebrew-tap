class Louder < Formula
  desc "Turn the Mac's volume up past 100%, for every app or just some"
  homepage "https://github.com/alxrxs/louder"
  url "https://github.com/alxrxs/louder.git",
      tag:      "v1.0.0",
      revision: "ead7d44455afc4805632f91922a353d796ea1620"
  license "GPL-3.0-only"
  head "https://github.com/alxrxs/louder.git", branch: "main"

  depends_on macos: :golden_gate

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"

    app = buildpath/"Louder.app/Contents"
    (app/"MacOS").install ".build/release/Louder"
    app.install "Resources/Info.plist"
    (app/"Resources").install "Resources/AppIcon.icns"
    system "/usr/libexec/PlistBuddy", "-c",
           "Set :CFBundleShortVersionString #{version}", app/"Info.plist"
    system "codesign", "--force", "--sign", "-", buildpath/"Louder.app"
    prefix.install "Louder.app"
  end

  def caveats
    <<~EOS
      Link Louder into Applications and launch it:
        ln -sfn #{opt_prefix}/Louder.app /Applications/Louder.app
        open /Applications/Louder.app

      Louder needs System Audio Recording permission (System Settings → Privacy &
      Security → Screen & System Audio Recording). Each install or upgrade is a new
      ad-hoc signature, so after `brew upgrade` remove Louder from that list and
      grant it again.
    EOS
  end

  test do
    assert_path_exists prefix/"Louder.app/Contents/MacOS/Louder"
    system "codesign", "--verify", prefix/"Louder.app"
  end
end
