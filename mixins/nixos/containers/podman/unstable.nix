{ config, pkgs, lib, ... }:

let
  podmanPackage = (pkgs.unstable.podman.override {
    extraPackages =
      # setuid shadow
      [ "/run/wrappers" ]
      ++ lib.optional (builtins.elem "zfs" config.boot.supportedFilesystems) config.boot.zfs.package;
  });
in
{
  imports = [
    ./_core.nix
  ];

  config = {
    virtualisation.podman.package = podmanPackage;

    environment.systemPackages = with pkgs.unstable; [
      podman-compose
    ];
  };
}
