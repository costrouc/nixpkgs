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
  version = "a79fd4a638b6995fc329ee653d2a5ead13b47201";
  disabled = (!isPy3k);

  src = fetchurl {
    url = "https://gitlab.com/costrouc/dftfit/-/archive/${version}/dftfit-${version}.tar.gz";
    sha256 = "0b0jjkj7dm0p3ry52ik97905vwwy41hhdcaw2bkqawdrrc3dhfkz";
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
