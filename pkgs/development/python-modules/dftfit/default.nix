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
  version = "d167bf99e6191123b79fd30ea79116eadbea6c2b";
  disabled = (!isPy3k);

  src = fetchurl {
    url = "https://gitlab.com/costrouc/dftfit/-/archive/${version}/dftfit-${version}.tar.gz";
    sha256 = "13rp0s983mwbvjibvhjyh8v1nlq64k9ylb0vv443529j221wd2yl";
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
