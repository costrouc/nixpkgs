{ lib
, fetchPypi, fetchurl
, buildPythonPackage
, pymatgen
, marshmallow
, pyyaml
, pygmo
, pandas
, scipy
, numpy
, scikitlearn
, lammps-cython
, pymatgen-lammps
, pytestrunner
, pytest
, pytestcov
, pytest-benchmark
, isPy3k
, openssh
}:

buildPythonPackage rec {
  pname = "dftfit";
  version = "230b3aad98e047b124691b49513dd7a9576afb2a";
  disabled = (!isPy3k);

  src = fetchurl {
    url = "https://gitlab.com/costrouc/dftfit/-/archive/${version}/dftfit-${version}.tar.gz";
    sha256 = "13chncgqq6g2456pfbnycikvg3jga3ii6sd9h4glrp04pdy158jm";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [ pytest pytestcov pytest-benchmark openssh ];
  propagatedBuildInputs = [ pymatgen marshmallow pyyaml pygmo
                            pandas scipy numpy scikitlearn
                            lammps-cython pymatgen-lammps ];

  # tests require git lfs download. and is quite large so skip tests
  doCheck = false;

  meta = {
    description = "Ab-Initio Molecular Dynamics Potential Development";
    homepage = https://gitlab.com/costrouc/dftfit;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
