{ pkgs
, stdenv
, lib
, hostPlatform

, linuxManualConfig
, runCommandNoCC

, fetchFromGitHub
, initramfs
, ...
}:

# Note:
# buildLinux cannot be used as `<pkgs/os-specific/linux/kernel/generic.nix>`
# assumed way too much about the kernel that is going to be built :<

let
  src = fetchFromGitHub {
    owner = "linux-3ds";
    repo = "linux";
    rev = "3810c17ac9d2e6eba24e536fffd00de8964ff1c4";
    sha256 = "1m06q83fp4rp1ng2ii4irqbbbwkfvjlpr4i2bz55qrbripcbsg98";
  };

  linuxConfig = import ./eval-config.nix {
    inherit pkgs;
    structuredConfig = with lib.kernel; {
      # we currently need to embed an initramfs. *firm_linux_loader* only loads kernel and dtb (and arm9 fw).
      # TODO: implement initramfs loading from "boot loader".
      INITRAMFS_SOURCE = freeform initramfs;
    };
  };

  defconfig = "${src}/arch/arm/configs/nintendo3ds_defconfig";

  # Merge config files.
  # NOTE: This does not allow *correct* overriding of values.
  #       E.g. it is impossible to "unset" a value this way.
  configfile = runCommandNoCC "linux-3ds-config" {} ''
    cat >> $out <<EOF
    #
    # From defconfig
    #
    EOF
    cat ${defconfig} >> $out
    cat >> $out <<EOF

    #
    # From structed attributes
    #
    ${linuxConfig.config}
    EOF
  '';
in

linuxManualConfig rec {
  # Required args
  inherit stdenv lib;

  version = "5.11.0-rc1";
  inherit src;
  inherit configfile;
}
