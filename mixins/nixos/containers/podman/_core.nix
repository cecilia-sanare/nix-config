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

    hardware.nvidia-container-toolkit.enable = isNvidia;
  };
}
