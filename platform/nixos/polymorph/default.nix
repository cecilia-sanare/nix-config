# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../../mixins/nixos/containers/podman/unstable.nix
  ];

  # TODO: Make this start jellyfin via docker

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kodi";

  dotfiles.apps.traefik = {
    enable = true;
    containers = true;

    letsencrypt = {
      enable = true;
      email = "admin@sanare.dev";
      provider = "route53";
      domains = [ "*.sanare.dev" ];
    };
  };

  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
    package = pkgs.mullvad-vpn;
  };
}
