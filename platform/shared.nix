# Default Shared Configuration
{ inputs, libx, username, outputs, desktop, hostname, platform, config, lib, pkgs, vscode-extensions, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    git
    killall
    gnumake
    gnupg
    ffmpeg
  ];

  fonts.packages = with pkgs; [
    noto-fonts
  ];

  networking.hostName = hostname;

  nixpkgs = {
    # Set your system kind (needed for flakes)
    hostPlatform = platform;

    overlays = (builtins.attrValues outputs.overlays) ++ [
      # inputs.nurpkgs.overlays.default
      inputs.protontweaks.overlay
      inputs.smart-open.overlay
    ] ++ lib.optional desktop.isNotPortable (self: super: {
        mutter = super.mutter.overrideAttrs (oldAttrs: {
          # Fixes the stutter issue present in the following:
          # - https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/1858#note_818548
          # - https://gitlab.gnome.org/GNOME/mutter/-/issues/398
          patches = (oldAttrs.patches or [ ]) ++ [
            ./mutter.patch
          ];
        });
      });

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

    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ username ];
      download-buffer-size = 500000000;

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;

      warn-dirty = false;
    };
  };

  home-manager = {
    # Pass flake inputs to our config
    extraSpecialArgs = {
      inherit inputs libx outputs desktop hostname platform vscode-extensions;
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";

    users.${username} = {
      imports = [
          inputs.protontweaks.homeManagerModules.protontweaks
        ../modules/home-manager
      ]
      # Try to load ../../users/{username}/home.nix
      ++ lib.optional (builtins.pathExists (./. + "/../users/${username}/home.nix")) ../users/${username}/home.nix;

      # Enable home-manager and git
      programs.home-manager.enable = true;
      programs.git.enable = true;

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";
    };
  };
}
