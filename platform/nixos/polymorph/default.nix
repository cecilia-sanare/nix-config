# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ ... }: {
  imports = [
    ./hardware.nix
    ../../../mixins/nixos/containers/podman/unstable.nix
  ];

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
}
