{ stdenv, fetchurl, pkgconfig, python, buildPythonPackage, isPy3k, isPyPy, wxGTK, openglSupport ? true, pyopengl }:

assert wxGTK.unicode;

buildPythonPackage rec {

  disabled = isPy3k || isPyPy;
  doCheck = false;

  version = "3.0.2.0";
  name = "wxPython-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "0qfzx3sqx4mwxv99sfybhsij4b5pc03ricl73h4vhkzazgjjjhfm";
  };

  buildInputs = [ pkgconfig wxGTK (wxGTK.gtk) ]
                ++ stdenv.lib.optional openglSupport pyopengl;

  preConfigure = "cd wxPython";

  setupPyBuildFlags = [ "WXPORT=gtk2" "NO_HEADERS=1" "BUILD_GLCANVAS=${if openglSupport then "1" else "0"}" "UNICODE=1" ];

  installPhase = ''
    ${python}/bin/${python.executable} setup.py ${stdenv.lib.concatStringsSep " " setupPyBuildFlags} install --prefix=$out
  '';

  inherit openglSupport;

  passthru = { inherit wxGTK openglSupport; };
}
