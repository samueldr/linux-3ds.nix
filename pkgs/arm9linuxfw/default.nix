{ stdenv
, fetchFromGitHub
, gcc-arm-embedded
, buildPackages
}:

stdenv.mkDerivation {
  pname = "arm9linuxfw";
  version = "unstable-2021-07-06";

  nativeBuildInputs = [
    gcc-arm-embedded
  ];

  makeFlags = [
    "CC=arm-none-eabi-gcc"
  ];

  src = fetchFromGitHub {
    owner = "linux-3ds";
    repo = "arm9linuxfw";
    rev = "206978444c04c65d1fc9e5a841196f7bd1623926";
    sha256 = "0ndhm7x5hlfqyxlcyfqplhydyzbjx0466ngmi9a65wsqi11x5sp3";
  };

  installPhase = ''
    # Output is named by the containing directory ¯\_(ツ)_/¯
    mv source.bin arm9linuxfw.bin
    ls -l
    mkdir -p $out
    cp -t $out \
      arm9linuxfw.bin
  '';
}
