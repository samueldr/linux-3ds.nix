final: super:

let
  inherit (final) callPackage;
in
{
  # Nintendo 3DS (CTR/RED product codes).
  ctr-packages = {
    firmtool = final.python3Packages.callPackage ./firmtool { };
  };
}
