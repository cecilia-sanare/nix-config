{ lib, libx, config, pkgs, desktop, ... }:

with lib;

let
  cfg = config.dotfiles.desktop;
  profileHashSub = with types; submodule
    {
      options = {
        url = mkOption {
          description = "Your profile picture";
          type = nullOr types.str;
          default = null;
        };

        sha256 = mkOption {
          description = "Your profile picture's hash";
          type = types.str;
          default = lib.fakeHash;
        };
      };
    };
in
{
  options.dotfiles.desktop = with types;
    {
      enable = mkEnableOption "desktop settings";

      systemFavorites = mkOption {
        description = "Favorites specified by the desktop environment";
        type = nullOr (listOf types.str);
        default = [ ];
      };

      favorites = mkOption {
        description = "Any apps you'd like to favorite. (used by various dock extensions)";
        type = listOf types.str;
        default = [ ];
      };

      picture = mkOption {
        description = "The profile picture path or url + hash";
        type = nullOr (types.oneOf [ types.path profileHashSub ]);
      };

      cursor = {
        enable = mkEnableOption "cursor overrides";

        url = mkOption {
          description = "The url of the cursor tar file";
          type = types.str;
        };

        hash = mkOption {
          description = "The hash of the tar file";
          type = types.str;
        };

        name = mkOption {
          description = "The hash of the tar file";
          type = types.str;
        };
      };
    };

  config = mkIf cfg.enable {
    home.pointerCursor = mkIf (libx.isLinux && cfg.cursor.enable) {
      gtk.enable = true;
      x11.enable = true;
      inherit (cfg.cursor) name;
      package = pkgs.runCommand "moveUp" { } ''
        mkdir -p $out/share/icons
        ln -s ${pkgs.fetchzip {
          inherit (cfg.cursor) url;
          inherit (cfg.cursor) hash;
        }} $out/share/icons/${cfg.cursor.name}
      '';
    };

    dconf.settings = {
      "org/gnome/shell".favorite-apps = cfg.systemFavorites ++ cfg.favorites;
    };

    home.file.".face" = mkIf (libx.isLinux && cfg.picture != null) {
      source = if builtins.typeOf cfg.picture == "path" then cfg.picture else
      builtins.fetchurl {
        inherit (cfg.picture) url;
        inherit (cfg.picture) sha256;
      };
    };
  };
}
