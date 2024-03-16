# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../../mixins/nixos/containers/podman/unstable.nix
  ];

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kodi";

  # Traefik Ports
  networking.firewall.allowedTCPPorts = [ 80 443 8080 ];

  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
    package = pkgs.mullvad-vpn;
  };
}
