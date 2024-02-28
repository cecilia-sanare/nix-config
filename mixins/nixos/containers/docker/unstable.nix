{ config, pkgs, ... }:

{
  imports = [
    ./_core.nix
  ];

  config = {
    virtualisation.docker.package = pkgs.unstable.docker;

    environment.systemPackages = with pkgs.unstable; [
      docker-compose
    ];
  };
}
