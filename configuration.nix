{ config, pkgs, ... }:

let
  host = "cecis-pc";
in
{
  system.stateVersion = "23.11";

  imports = [
    ./modules
    ./packages
    ./hosts/${host}.nix
  ];

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
}
