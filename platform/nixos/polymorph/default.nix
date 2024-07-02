# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../../mixins/nixos/containers/podman/unstable.nix
  ];

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kodi";

  dotfiles.gaming = {
    enable = true;
    ports.presets = [ "steam" "lidgren" ];
  };

  # Traefik Ports & Jellyfin Port for Offline Mode
  networking.firewall.allowedTCPPorts = [ 80 443 8080 8096 ];

  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
    package = pkgs.mullvad-vpn;
  };
}
