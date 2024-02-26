{ config, lib, pkgs, modulesPath, ... }:

{
  # Host config for my desktop

  # Old OS
  fileSystems."/mnt/old" = {
    device = "/dev/nvme0n1p1";
    fsType = "ext4";
  };

  fileSystems."/mnt/media" = {
    device = "/dev/nvme2n1p1";
    fsType = "ext4";
  };

  dotfiles = {
    # users.ceci = {
    #   name = "Cecilia Sanare";
    # };

    containers.enable = true;
    desktop.enable = true;

    gpu = {
      enable = true;
      vendor = "nvidia";
    };
  };
}