require "formula"

class Kf5Knotifications < Formula

  head 'git://anongit.kde.org/knotifications.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"

  def patches
    DATA
  end

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=\"#{Formula.factory('qt5').opt_prefix};#{Formula.factory('kf5-extra-cmake-modules').opt_prefix}\""

    system "cmake", ".", *args
    system "make", "install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 63ebf71..f4cbf81 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -27,7 +27,9 @@ include(KDEInstallDirs)
 include(KDEFrameworkCompilerSettings)
 include(KDECMakeSettings)
 
-find_package(X11)
+if (NOT APPLE)
+    find_package(X11)
+endif()
 set(HAVE_X11 ${X11_FOUND})
 set(HAVE_XTEST ${X11_XTest_FOUND})
 if(X11_FOUND)