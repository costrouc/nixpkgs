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
  version = "ab21a94e8dc9a23e469e9bc5afef9b416a48a236";
  disabled = (!isPy3k);

  src = fetchurl {
    url = "https://gitlab.com/costrouc/dftfit/-/archive/${version}/dftfit-${version}.tar.gz";
    sha256 = "09zr81nl9rrvh2j6qz26cbd8dqcv0652yzc7b274dv02gxyx857d";
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
