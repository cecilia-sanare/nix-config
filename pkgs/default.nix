# Custom packages, that can be defined similarly to ones from nixpkgs
# Build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }:
let
  skins = {
    arctic-zephyr = pkgs.kodiPackages.callPackage ./kodiSkins/arctic-zephyr.nix { };
  };
in
{
  kodiSkins = skins;
}
