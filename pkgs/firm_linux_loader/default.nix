{ stdenv
, fetchFromGitHub
, gcc-arm-embedded
, buildPackages
}:

stdenv.mkDerivation {
  pname = "firm_linux_loader";
  version = "unstable-2021-05-13";

  src = fetchFromGitHub {
    owner = "linux-3ds";
    repo = "firm_linux_loader";
    rev = "4098b022833bb794383cbf269d6e39a887fc3354";
    sha256 = "0mh1iw1l8a69rx4lxkmmpnhw5rpz11lsn2iyg31a3gyikg8frap3";
  };

  patches = [
    ./initramfs-support.patch
  ];

  nativeBuildInputs = [
    gcc-arm-embedded
    buildPackages.ctr-packages.firmtool
  ];

  makeFlags = [
    "CC=arm-none-eabi-gcc"
  ];

  installPhase = ''
    mkdir -p $out
    cp -t $out \
      firm_linux_loader.firm
  '';
}
