# Default Shared Configuration
{ inputs, username, outputs, desktop, hostname, platform, stateVersion, config, lib, pkgs, vscode-extensions, ... }:

{
  imports = [
    inputs.nix-desktop.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    ../../modules/platform/nixos
    ./${hostname}
  ]
  # Try to load ../../users/{username}/nixos.nix
  ++ lib.optional (builtins.pathExists (./. + "/../../users/${username}/nixos.nix")) ../../users/${username}/nixos.nix;

  environment.systemPackages = with pkgs; [
    vim
    git
    killall
    gnumake
    gnupg
    apple-cursor
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.master-packages
      inputs.nurpkgs.overlay
      inputs.protontweaks.overlay
      inputs.smart-open.overlay
    ];

    config = {
      allowUnfree = true;
    };
  };

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
