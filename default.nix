{ pkgs ? import ./pkgs.nix {
  overlays = [(import ./pkgs)];
} }:

let
  # pkgsCross.nintendo3DS when?
  armv6 = pkgs.pkgsCross.raspberryPi;
in
armv6.ctr-packages // {
  # These are build-time packages.
  # So let's cheat a bit, since we cheated with armv6.
  firmtool = pkgs.ctr-packages.firmtool;
}
