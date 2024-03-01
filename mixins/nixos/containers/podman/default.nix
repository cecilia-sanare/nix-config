{ config, pkgs, ... }:

{
  imports = [
    ./_core.nix
  ];

  config = {
    virtualisation.podman.package = pkgs.stable.podman.override {
      extraPackages = cfg.extraPackages
        # setuid shadow
        ++ [ "/run/wrappers" ]
        ++ lib.optional (config.boot.supportedFilesystems.zfs or false) config.boot.zfs.package;
    };

    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
