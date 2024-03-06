# Default Shared Configuration
{ inputs, username, outputs, desktop, hostname, platform, stateVersion, config, lib, pkgs, vscode-extensions, ... }:

{
  imports = [
    inputs.nix-desktop.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    ../../modules/nixos
    ./${hostname}
  ]
  # Try to load ../../users/{username}/nixos.nix
  ++ lib.optional (builtins.pathExists (./. + "/../../users/${username}/nixos.nix")) ../../users/${username}/nixos.nix;

  environment.systemPackages = with pkgs;
    [
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

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    optimise.automatic = true;
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;

      warn-dirty = false;
    };
  };

  boot.loader.systemd-boot.enable = true;

  networking.hostName = hostname;

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

  home-manager = {
    # Pass flake inputs to our config
    extraSpecialArgs = {
      inherit inputs outputs desktop hostname platform vscode-extensions;
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";

    users.${username} = {
      imports = [
        ../../modules/home-manager
      ]
      # Try to load ../../users/{username}/home.nix
      ++ lib.optional (builtins.pathExists (./. + "/../../users/${username}/home.nix")) ../../users/${username}/home.nix;

      # Enable home-manager and git
      programs.home-manager.enable = true;
      programs.git.enable = true;

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      home.stateVersion = stateVersion;
    };
  };

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
