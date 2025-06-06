# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../../mixins/nixos/containers/podman/unstable.nix
  ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kodi";

  dotfiles.gaming = {
    enable = true;
    ports.presets = [ "minecraft" "steam" "lidgren" "mariadb" ];
  };

  # Traefik Ports & Jellyfin Port for Offline Mode
  networking.firewall.allowedTCPPorts = [ 80 443 8080 8096 ];

  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
    package = pkgs.mullvad-vpn;
  };
}
