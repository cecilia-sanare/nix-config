{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  host = "cecis-pc";
in
{
  system.stateVersion = "23.11";

  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
    ./modules
    ./packages
    ./hosts/${host}.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
}
