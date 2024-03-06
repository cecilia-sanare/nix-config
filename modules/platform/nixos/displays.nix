{ config, lib, ... }:

with lib;

let
  cfg = config.dotfiles;
in
{
  options.dotfiles.displays = mkOption {
    description = "The config for each display";
    type = with types; listOf (submodule {
      options = {
        enable = mkOption {
          description = "Whether this display is enabled";
          type = bool;
          default = true;
        };
        name = mkOption {
          description = "The xrandr name for the display";
          type = enum [
            "DP-1"
            "DP-2"
            "DP-3"
            "DP-4"
            "eDP-1"
            "HDMI-1"
            "HDMI-2"
            "HDMI-3"
            "DP-1-4"
            "DP-1-5"
            "DP-1-6"
            "eDP-1-2"
          ];
        };
        fingerprint = mkOption {
          # Can be obtained via 'nix-shell -p autorandr --command "autorandr --fingerprint"'
          description = "The unique identifier for the display";
          type = str;
        };
        primary = mkOption {
          description = "Whether the display is the primary display";
          type = bool;
          default = false;
        };
        resolution = mkOption {
          description = "The resolution of the display e.g. 2560x1440";
          type = str;
        };
        position = mkOption {
          description = "???";
          type = str;
        };
        rate = mkOption {
          description = "The refresh rate of the display";
          type = str;
        };
      };
    });
  };

  config = {
    # TODO: Figure out why this isn't effecting the greeter
    services.autorandr = {
      enable = true;
      profiles = {
        home = {
          fingerprint = builtins.listToAttrs (map (v: { inherit (v) name; value = v.fingerprint; }) cfg.displays);
          config = builtins.listToAttrs (map
            (v: {
              inherit (v) name;
              value = {
                inherit (v) enable;
                mode = v.resolution;
                inherit (v) primary;
                inherit (v) position;
                inherit (v) rate;
              };
            })
            cfg.displays);
        };
      };
    };
  };
}

