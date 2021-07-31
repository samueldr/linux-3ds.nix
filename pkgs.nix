let
  rev = "8ecc61c91a596df7d3293603a9c2384190c1b89a";
  sha256 = "0vhajylsmipjkm5v44n2h0pglcmpvk4mkyvxp7qfvkjdxw21dyml";
in
import (
  builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  }
)
