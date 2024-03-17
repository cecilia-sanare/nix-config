{ lib, config, pkgs, ... }:

let
  cfg = config.dotfiles.gaming;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.dotfiles.gaming.gamemode = {
    enable = mkEnableOption "gamemode" // {
      default = true;
    };

    notify = mkEnableOption "notify when started";
  };

  config = mkIf (cfg.enable && cfg.gamemode.enable) {
    programs.gamemode = {
      enable = true;
      settings = mkIf cfg.gamemode.notify {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
