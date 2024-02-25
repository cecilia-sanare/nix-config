{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose  
  ];

  networking.firewall = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [80 443];
  };
}