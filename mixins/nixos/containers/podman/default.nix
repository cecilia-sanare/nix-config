{ config, pkgs, ... }:

{
  imports = [
    ./_core.nix
  ];

  config = {
    virtualisation.podman.package = kgs.unstable.podman.override {
      extraPackages = cfg.extraPackages
        # setuid shadow
        ++ [ "/run/wrappers" ]
        ++ lib.optional (builtins.elem "zfs" config.boot.supportedFilesystems) config.boot.zfs.package;
    };

    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
