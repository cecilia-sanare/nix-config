{ config, ... }:

let
  isNvidia = builtins.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  imports = [
    ../_core.nix
  ];

  config = {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    virtualisation.containers.cdi.dynamic.nvidia.enable = isNvidia;
  };
}
