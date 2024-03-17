{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./gamemode.nix
    ./ports.nix
    ./steam.nix
  ];

  options.dotfiles.gaming.enable = mkEnableOption "gaming support";
}
