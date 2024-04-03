# Default Shared Configuration
{ username, desktop, platform, stateVersion, config, pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../mixins/nixos/shells/fish
    ../../mixins/nixos/containers/podman/unstable.nix
  ];

  environment.systemPackages = with pkgs; [
    apple-cursor
  ];

  nix.optimise.automatic = true;

  boot.loader.systemd-boot.enable = true;
  hardware.logitech.wireless.enable = true;

  users.users.${username} = {
    name = username;
    initialPassword = if config.users.users.${username}.hashedPassword == null then "changeme" else null;
    isNormalUser = true;

    # Assume they're a sudoer.
    # NOTE: This will need to be configurable if more users are ever added (which they probably won't be)
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nix-desktop = {
    enable = true;
    inherit (desktop) type preset;
    # Disable sleep if this isn't a portable device
    sleep = desktop.isPortable;

    workspaces.number = mkDefault 1;
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  home-manager.users.${username}.home.stateVersion = stateVersion;

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = platform;

  system.stateVersion = stateVersion;
}
