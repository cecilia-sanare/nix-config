{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles;
in
{
  options.dotfiles.users = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        name = mkOption {
          description = "The display name of the user";
          type = types.str;
          default = true;
        };

        background = mkOption {
          description = "The wallpaper background";
          type = nullOr (types.str);
          default = null;
        };

        extensions = mkOption {
          description = "Any gnome extensions you want to enable";
          type = listOf (types.package);
        };

        favorites = mkOption {
          description = "Any apps you'd like to favorite. (used by various dock extensions)";
          type = listOf (types.str);
        };

        dconf = mkOption {
          description = "Any dconf settings you'd like to set";
          type = attrsOf (attrsOf (types.anything));
          # TODO: Is there any way I can get access to home managers gvariant type?
          # type = with types; attrsOf (attrsOf hm.types.gvariant);
        };

        cursor = {
          enable = mkOption {
            description = "Whether the cursor should be overridden";
            type = types.bool;
            default = false;
          };

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

        groups = mkOption {
          description = "Any groups this user should be part of";
          type = listOf (types.str);
          default = [ ];
        };

        sudoer = mkOption {
          description = "Whether this user should have the 'wheel' group";
          type = types.bool;
        };

        stateVersion = mkOption {
          description = "The home-manager state version";
          type = types.str;
        };
      };
    });
  };

  config = mkMerge [
    # Defaults
    (
      let
        default = cfg.users.default;
      in
      mkIf (default != null) {
        environment.systemPackages = default.extensions;

        home-manager.sharedModules = [{
          home = {
            pointerCursor = mkIf (default.cursor.enable) {
              gtk.enable = true;
              x11.enable = true;
              name = default.cursor.name;
              package = pkgs.runCommand "moveUp" { } ''
                mkdir -p $out/share/icons
                ln -s ${pkgs.fetchzip {
                  url = default.cursor.url;
                  hash = default.cursor.hash;
                }} $out/share/icons/${default.cursor.name}
              '';
            };

            stateVersion = default.stateVersion;
          };

          dconf.settings = mkMerge [
            {
              "org/gnome/desktop/background" = {
                picture-uri-light = "${default.background}";
                picture-uri-dark = "${default.background}";
              };

              "org/gnome/desktop/interface" = {
                enable-hot-corners = false;
                clock-format = "12h";
              };

              "org/gnome/shell" = {
                enabled-extensions = map (x: x.extensionUuid) default.extensions;
                # Located in /run/current-system/sw/share/applications
                favorite-apps = default.favorites;
              };

              "org/gnome/mutter" = {
                edge-tiling = true;
                # TODO: Disable activities hotkey once I find an application launcher
                # overlay-key = "";
                dynamic-workspaces = false;
              };

              "org/gnome/desktop/wm/preferences" = {
                button-layout = ":minimize,maximize,close";
                num-workspaces = 1;
              };
            }
            default.dconf
          ];
        }];
      }
    )
    # Individual users
    {
      users.users = builtins.mapAttrs
        (name: value: mkIf (name != "default") {
          isNormalUser = true;
          description = value.name;
          extraGroups = value.groups ++ lib.optionals (value.sudoer) [
            "networkmanager" # What does this group do?
            "wheel"
          ];
        })
        cfg.users;

      # *Always* initialize a INDIVIDUAL home manager user otherwise everything else will break.
      home-manager.users = builtins.mapAttrs
        (name: value: mkIf (name != "default") {
          home.stateVersion = "23.11";
        })
        cfg.users;
    }
  ];
}
