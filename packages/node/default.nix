{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles.packages.node;
in
{
  options.dotfiles.packages.node = with types; {
    enable = mkEnableOption "Enable the node package";
    bun = mkOption {
      description = "Enable the bun package";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      fnm
      (mkIf (cfg.bun) bun)
    ];
  };
}
