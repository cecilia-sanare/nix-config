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
  };

  config = mkIf (cfg.enable) {
    dconf.settings = {
      "org/gnome/desktop/background" = mkIf (desktop == "gnome" && cfg.background != null) {
        picture-uri-dark = "${cfg.background}";
      };
    };
  };
}
