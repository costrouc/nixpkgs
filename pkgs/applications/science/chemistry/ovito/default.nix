{ stdenv, fetchgit
, pkgs, cmake
, libav, netcdf, qscintilla, zlib, boost, git, fftw, hdf5, libssh
, sphinx, numpy, sip, pyqt5, matplotlib, ase
}:

stdenv.mkDerivation rec {
  # compilation error in 2.9.0 https://gitlab.com/stuko/ovito/issues/40
  # This is not the "released" 3.0.0 just a commit
  version = "3.0.0";
  name = "ovito-${version}";

  src = fetchgit {
    url = "https://gitlab.com/stuko/ovito";
    rev = "a28c28182a879d2a1b511ec56f9845306dd8a4db";
    sha256 = "1vqzv3gzwf8r0g05a7fj8hdyvnzq2h3wdfck7j6n1av6rvp7hi5r";
  };

  buildInputs = [ cmake libav netcdf qscintilla zlib boost zlib git fftw hdf5 libssh ];
  propagatedBuildInputs = [ sphinx numpy sip pyqt5 matplotlib ase ];

  enableParallelBuilding = true;

  # postFixup = ''
  #   wrapProgram $out/bin/ovito \
  #     --prefix QT_PLUGIN_PATH : "${pkgs.qt5.qtbase}/${pkgs.qt5.qtbase.qtPluginPrefix}"
  # '';

  meta = with stdenv.lib; {
    description = "Scientific visualization and analysis software for atomistic simulation data";
    homepage = https://www.ovito.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };
}
