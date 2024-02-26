{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles.containers;
in
{
  options.dotfiles.containers = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    tool = mkOption {
      type = types.nullOr (types.enum [ "docker" "podman" ]);
      default = "podman";
    };

    discovery = mkOption {
      description = "Opens up http(s) ports if service discovery is going to be utilized.";
      type = types.bool;
      default = true;
    };
  };

  config =
    let
      docker = cfg.tool == "docker";
      podman = cfg.tool == "podman";
    in
    mkIf (cfg.enable) {
      virtualisation.docker = mkIf (docker) {
        enable = true;

        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };

      virtualisation.podman = mkIf (podman) {
        enable = true;
        enableNvidia = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      environment.systemPackages = with pkgs; [
        (mkIf (docker) docker-compose)
        (mkIf (podman) podman-compose)
      ];

      # TODO: Move this somewhere else
      networking.firewall = {
        allowedTCPPorts = mkIf (cfg.discovery) [ 80 443 ];
        allowedUDPPorts = mkIf (cfg.discovery) [ 80 443 ];
      };

      boot.kernel.sysctl = {
        "net.ipv4.ip_unprivileged_port_start" = 0;
      };
    };
}
