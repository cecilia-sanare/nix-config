# Default Shared Configuration
{ inputs, username, outputs, desktop, hostname, platform, stateVersion, lib, vscode-extensions, ... }:

{
  imports = [
    inputs.nix-desktop.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    ../../modules/nix-darwin
  ]
  # Try to load ./{hostname}/default.nix or ./{hostname}.nix
  ++ lib.optional (builtins.pathExists (./. + "/${hostname}/default.nix")) ./${hostname}
  ++ lib.optional (builtins.pathExists (./. + "/${hostname}.nix")) ./${hostname}.nix
  # Try to load ../../users/{username}/darwin.nix
  ++ lib.optional (builtins.pathExists (./. + "/../../users/${username}/darwin.nix")) ../../users/${username}/darwin.nix;

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
        (import ../modules/home-manager)
      ]
      # Try to load ../users/{username}/default.nix or ../users/{username}.nix
      ++ lib.optional (builtins.pathExists (./. + "/../users/${username}/home.nix")) ../users/${username}/home.nix;

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
