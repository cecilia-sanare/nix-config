{ config, pkgs, ... }:

{
  imports = [
    ./_core.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
