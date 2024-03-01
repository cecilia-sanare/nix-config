{ config, pkgs, lib, ... }:

{
  imports = [
    ./_core.nix
  ];

  config = {
    virtualisation.podman.package = (pkgs.podman.override {
      extraPackages =
        # setuid shadow
        [ "/run/wrappers" ]
        ++ lib.optional (config.boot.supportedFilesystems.zfs or false) config.boot.zfs.package;
    });

    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
