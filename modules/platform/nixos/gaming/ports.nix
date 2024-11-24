{ lib, config, pkgs, ... }:

let
  cfg = config.dotfiles.gaming;

  presets = {
    "minecraft" = {
      tcp = [
        25565
      ];
      udp = [
        25565
      ];
    };
    "steam" = {
      tcp = [
        27015
        27036
      ];
      udp = [
        27015
        27016
        27036
        27031
        27032
        27033
        27034
        27035
        27036
      ];
    };
    "satisfactory" = {
      tcp = [
        7777
      ];
      udp = [
        7777
      ];
    };
    "lidgren" = {
      tcp = [
        9876
      ];
      udp = [
        9876
      ];
    };
  };

  getPortsFromPresets = type: (builtins.concatMap (name: presets.${name}.${type}) cfg.ports.presets);

  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (types) listOf;
in
{
  options.dotfiles.gaming.ports = {
    enable = mkEnableOption "port management" // {
      default = true;
    };

    tcp = mkOption {
      description = "The ports you'd like to open";
      type = listOf types.number;
      default = [ ];
    };

    udp = mkOption {
      description = "The ports you'd like to open";
      type = listOf types.number;
      default = [ ];
    };

    presets = mkOption {
      description = "The port presets you'd like to apply";
      type = listOf (types.enum [ "minecraft" "steam" "lidgren" "satisfactory" ]);
      default = [ ];
    };
  };

  config =
    let
      tcp-ports = cfg.ports.tcp ++ getPortsFromPresets "tcp";
      udp-ports = cfg.ports.udp ++ getPortsFromPresets "udp";
    in
    mkIf (cfg.enable && cfg.ports.enable) {
      networking.firewall.allowedTCPPorts = tcp-ports;
      networking.firewall.allowedUDPPorts = udp-ports;
    };
}
