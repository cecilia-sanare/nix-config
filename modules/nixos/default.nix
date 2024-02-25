{ config, pkgs, ... }:

{
  imports = [
    ./1password
    ./zsh
    ./docker
    ./vscode
    ./discord
    ./gaming
  ];

  nixpkgs.config.allowUnfree = true;
  services.gnome.core-utilities.enable = false;

  environment.gnome.excludePackages = with pkgs; [ 
    gnome-tour
  ];

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.hide-activities-button
    gnomeExtensions.just-perfection
    gnomeExtensions.search-light
    gnomeExtensions.dash-to-dock
    gnome.gnome-terminal
    vim
    git
    gnumake
    firefox
    slack
    gparted
  ];
}
