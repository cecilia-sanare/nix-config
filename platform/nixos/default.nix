# Default Shared Configuration
{ inputs, username, outputs, desktop, hostname, platform, stateVersion, config, lib, pkgs, vscode-extensions, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    vim
    git
    killall
    gnumake
    gnupg
    apple-cursor
  ];

  nix.optimise.automatic = true;

  boot.loader.systemd-boot.enable = true;

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
    sleep = false;

    workspaces.number = 1;
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
