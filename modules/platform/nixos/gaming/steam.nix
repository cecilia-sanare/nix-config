{ lib, config, pkgs, ... }:

let
  cfg = config.dotfiles.gaming;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.dotfiles.gaming.steam = {
    enable = mkEnableOption "steam" // {
      default = true;
    };
  };

  config = mkIf (cfg.enable && cfg.steam.enable) {
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
  };
}
