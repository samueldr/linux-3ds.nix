final: super:

let
  inherit (final) callPackage;
in
{
  mkCpio = callPackage ./mkCpio {
    linux = final.linux_5_10;
  };
  # Nintendo 3DS (CTR/RED product codes).
  ctr-packages = {
    arm9linuxfw = callPackage ./arm9linuxfw { };
    firm_linux_loader = callPackage ./firm_linux_loader { };
    firmtool = final.python3Packages.callPackage ./firmtool { };
    linux = callPackage ./linux {
      kernelPatches = with final.kernelPatches; [
        bridge_stp_helper
        request_key_helper
      ];
      initramfs = ''"${final.ctr-packages.minimal-initramfs}/files.list"'';
    };
    minimal-initramfs = callPackage ./minimal-initramfs { };
    sdcard-filesystem = callPackage ./sdcard-filesystem { };
  };
}
