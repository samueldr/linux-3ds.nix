final: super:

let
  inherit (final) callPackage;
in
{
  # Nintendo 3DS (CTR/RED product codes).
  ctr-packages = {
    firm_linux_loader = callPackage ./firm_linux_loader { };
    firmtool = final.python3Packages.callPackage ./firmtool { };
  };
}
