{ lib
, buildPythonPackage
, fetchFromGitHub
, pycryptodome
}:

buildPythonPackage {
  pname = "firmtool";
  version = "unstable-2020-12-26";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "TuxSH";
    repo = "firmtool";
    rev = "fdc7085c2394d87ce5dbdfecdf51423e1e7b00a1";
    sha256 = "0pa5w0h3nj53xdm69sfp1834vijknggndqnjp84f346vfrwcryzd";
  };

  propagatedBuildInputs = [
    pycryptodome
  ];
}
