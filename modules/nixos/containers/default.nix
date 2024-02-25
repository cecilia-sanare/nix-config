{ config, pkgs, lib, ... }:

with lib;
with builtins; let
  cfg = config.sys.virtualisation;
in {
  options.sys.virtualisation = {
    containers = mkOption {
      description = "The containerization format to use (docker or podman)";
      type = types.nullOr (types.enum ["podman" "docker"]);
      default = "podman";
    };
    discovery = mkOption {
      description = "Opens up http(s) ports if service discovery is going to be utilized.";
      type = types.bool;
    };
  };

  config = {
    virtualisation.docker = mkIf (cfg.containers == "docker") {
      enable = true;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    virtualisation.podman = mkIf (cfg.containers == "podman") {
      enable = true;
      enableNvidia = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      (mkIf (cfg.containers == "podman") podman-compose)
      (mkIf (cfg.containers == "docker") docker-compose)
    ];

    networking.firewall = {
      allowedTCPPorts = mkIf (cfg.discovery) [80 443];
      allowedUDPPorts = mkIf (cfg.discovery) [80 443];
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 80;  
    };
  };
}