class P7sOpener < Formula
  desc "Double-click a .p7s file and get the document inside"
  homepage "https://github.com/alxrxs/p7s-opener"
  url "https://github.com/alxrxs/p7s-opener.git",
      tag:      "v1.0.0",
      revision: "d96b159ceaf36a7e2df259ba9e51d4a1401000a6"
  license "GPL-3.0-only"
  head "https://github.com/alxrxs/p7s-opener.git", branch: "main"

  depends_on macos: :golden_gate

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"

    app = buildpath/"P7S Opener.app/Contents"
    (app/"MacOS").install ".build/release/P7SOpener"
    app.install "Resources/Info.plist"
    (app/"Resources").install "Resources/AppIcon.icns"
    system "/usr/libexec/PlistBuddy", "-c",
           "Set :CFBundleShortVersionString #{version}", app/"Info.plist"
    system "codesign", "--force", "--sign", "-", buildpath/"P7S Opener.app"
    prefix.install "P7S Opener.app"
  end

  def caveats
    <<~EOS
      Link P7S Opener into Applications and open it once, so double-clicking a
      .p7s or .p7m file opens it:
        ln -sfn "#{opt_prefix}/P7S Opener.app" "/Applications/P7S Opener.app"
        open "/Applications/P7S Opener.app"
    EOS
  end

  test do
    assert_path_exists prefix/"P7S Opener.app/Contents/MacOS/P7SOpener"
    system "codesign", "--verify", prefix/"P7S Opener.app"
  end
end
