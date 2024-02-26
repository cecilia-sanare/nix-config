{ lib, config, ... }:

with lib;

let
  cfg = config.dotfiles.network;
in
{
  options.dotfiles.network = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    wifi = mkOption {
      type = types.bool;
      default = false;
    };

    hostName = mkOption {
      type = types.str;
      default = "nixos";
    };

    printing = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.hostName = cfg.hostName;
    networking.networkmanager.enable = true;
    # Enables wireless support via wpa_supplicant.
    networking.wireless.enable = cfg.wifi;
    services.printing.enable = cfg.printing;
  };
}

