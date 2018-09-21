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
, gsd
, pytestrunner
, pytest
, pytestcov
, isPy3k
, openssh
}:

buildPythonPackage rec {
  pname = "lammps-cython";
  version = "127be95aec2b6e55fcb6ab2a205e323309210974";
  disabled = (!isPy3k);

  src = fetchurl {
    url = "https://gitlab.com/costrouc/lammps-cython/-/archive/127be95aec2b6e55fcb6ab2a205e323309210974/lammps-cython-127be95aec2b6e55fcb6ab2a205e323309210974.tar.gz";
    sha256 = "1zzayb9794mvakj0zd7h5ki0nkq7dia71dw2ww2sdfwk3adk0d6d";
  };

  buildInputs = [ cython pytestrunner ];
  checkInputs = [ pytest pytestcov openssh ];
  propagatedBuildInputs = [ mpi4py numpy pymatgen ase gsd ];

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
