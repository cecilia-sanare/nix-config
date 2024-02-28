{ lib, config, pkgs, desktop, ... }:

with lib;

let
  cfg = config.dotfiles.desktop;
in
{
  options.dotfiles.desktop = with types; {
    enable = mkEnableOption "desktop settings";

    background = mkOption {
      description = "The wallpaper you'd like!";
      type = nullOr (types.str);
    };

    favorites = mkOption {
      description = "Any apps you'd like to favorite. (used by various dock extensions)";
      type = nullOr (listOf (types.str));
    };
  };

  config = mkIf (cfg.enable) {
    dconf.settings = mkMerge [
      (mkIf (desktop == "gnome") {
        "org/gnome/desktop/background" = mkIf (cfg.background != null) {
          picture-uri-dark = "${cfg.background}";
        };
        "org/gnome/shell" = mkIf (cfg.favorites != null) {
          # Located in /run/current-system/sw/share/applications
          favorite-apps = cfg.favorites;
        };
      })
    ];
  };
}
