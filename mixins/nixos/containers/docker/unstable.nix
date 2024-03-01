{ config, pkgs, ... }:

{
  imports = [
    ./_core.nix
  ];

  config = {
    virtualisation.docker.package = pkgs.docker;

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
