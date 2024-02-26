{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles.packages.rust;
in
{
  options.dotfiles.packages.rust = with types; {
    enable = mkEnableOption "Enable the rust package";
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      rustup
    ];
  };
}
