{ config, pkgs, ... }:

{
  imports = [
    ../_core.nix
  ];

  config = {
    virtualisation.podman = {
      enable = true;
      enableNvidia = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
