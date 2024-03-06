# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ ... }: {
  imports = [
    ./hardware.nix
    ../../mixins/nixos/containers/podman
  ];

  users.users.ceci.hashedPassword = "$6$P9EJMHnu8b/OVVRS$1qECnQmYav5EhbnTOk3mnO3dBlMOAsF9/lgCRONwO/GHUfHZFIpxYSyOTPqpv6S6dqO4uSxSZ9KMDl5yX9AHH1";

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
