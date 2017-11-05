require "formula"

class Konsole < Formula
  desc "KDE's terminal emulator"
  homepage "http://www.kde.org/"
  url "https://download.kde.org/stable/applications/17.08.2/src/konsole-17.08.2.tar.xz"
  sha256 "02777e8bc545d2534ee97b25e745109fc084937050e6e4af9a5c9a6395d0f328"

  head "git://anongit.kde.org/konsole.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "kde-mac/kde/kf5-kdoctools" => :build

  depends_on "qt"
  depends_on "KDE-mac/kde/kf5-knotifyconfig"
  depends_on "KDE-mac/kde/kf5-kpty"
  depends_on "KDE-mac/kde/kf5-kparts"
  depends_on "KDE-mac/kde/kf5-kinit"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{prefix}/bin"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
      system "/usr/libexec/PlistBuddy",
        "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
        "#{bin}/konsole.app/Contents/Info.plist"
    end
  end

  def post_install
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/konsole/icontheme.rcc"
  end

  def caveats; <<-EOS.undent
    You need to take some manual steps in order to make this formula work:
      ln -sf "$(brew --prefix)/share/konsole" ~/Library/"Application Support"
      mkdir -p ~/Applications/KDE
      ln -sf "#{prefix}/bin/konsole.app" ~/Applications/KDE/
    EOS
  end
end
