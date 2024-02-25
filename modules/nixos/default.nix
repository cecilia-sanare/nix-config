{ config, pkgs, ... }:

{
  imports = [
    ./1password
    ./zsh
    ./docker
    ./vscode
    ./discord
    ./gaming
    ./hardware
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
    gnome.gnome-terminal
    gnome.nautilus
    gparted
    vim
    git
    gnumake
    firefox
    slack
    zoom-us
    spotify
    # TODO: This doesn't do anything right now... why?
    # jellyfin-web
  ];
}
