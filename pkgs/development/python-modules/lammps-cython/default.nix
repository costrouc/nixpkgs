{ lib
, fetchurl
, buildPythonPackage
, lammps-mpi
, mpi
, mpi4py
, numpy
, cython
, pymatgen
, ase
, pytestrunner
, pytest
, pytestcov
, isPy3k
, openssh
}:

buildPythonPackage rec {
  pname = "lammps-cython";
  version = "f40ec131a853d824d5c829b689baf5ddddd7057e";
  disabled = (!isPy3k);

  src = fetchurl {
    url = "https://gitlab.com/costrouc/lammps-cython/-/archive/f40ec131a853d824d5c829b689baf5ddddd7057e/lammps-cython-f40ec131a853d824d5c829b689baf5ddddd7057e.tar.gz";
    sha256 = "17av27lq2p8nxfbx8blaq3vbr4bjm66h40awi43z8p6qlf307igq";
  };

  buildInputs = [ cython pytestrunner ];
  checkInputs = [ pytest pytestcov openssh ];
  propagatedBuildInputs = [ mpi4py pymatgen ase numpy ];

  preBuild = ''
    echo "Creating lammps.cfg file..."
    cat << EOF > lammps.cfg
    [lammps]
    lammps_include_dir = ${lammps-mpi}/include
    lammps_library_dir = ${lammps-mpi}/lib
    lammps_library = lammps_mpi

    [mpi]
    mpi_include_dir = ${mpi}/include
    mpi_library_dir = ${mpi}/lib
    mpi_library     = mpi
    EOF
  '';

  meta = {
    description = "Pythonic Wrapper to LAMMPS using cython";
    homepage = https://gitlab.com/costrouc/lammps-cython;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
