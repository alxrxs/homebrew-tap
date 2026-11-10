class Flipane < Formula
  desc "Cmd-Tab replacement that switches windows, not apps"
  homepage "https://github.com/alxrxs/flipane"
  url "https://github.com/alxrxs/flipane.git",
      tag:      "v1.0.0",
      revision: "65f91858ef6e1529c6fc582a9d13a551a5e110e6"
  license "GPL-3.0-only"
  head "https://github.com/alxrxs/flipane.git", branch: "main"

  depends_on macos: :golden_gate

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"

    app = buildpath/"Flipane.app/Contents"
    (app/"MacOS").install ".build/release/Flipane"
    app.install "Resources/Info.plist"
    (app/"Resources").install "Resources/AppIcon.icns"
    system "/usr/libexec/PlistBuddy", "-c",
           "Set :CFBundleShortVersionString #{version}", app/"Info.plist"
    system "codesign", "--force", "--sign", "-", buildpath/"Flipane.app"
    prefix.install "Flipane.app"
  end

  def caveats
    <<~EOS
      Link Flipane into Applications and launch it:
        ln -sfn #{opt_prefix}/Flipane.app /Applications/Flipane.app
        open /Applications/Flipane.app

      Flipane needs Accessibility permission (System Settings → Privacy & Security →
      Accessibility). Each install or upgrade is a new ad-hoc signature, so after
      `brew upgrade` remove Flipane from that list and grant it again.
    EOS
  end

  test do
    assert_path_exists prefix/"Flipane.app/Contents/MacOS/Flipane"
    system "codesign", "--verify", prefix/"Flipane.app"
  end
end
