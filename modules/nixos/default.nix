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
    gnome.gnome-terminal
    vim
    git
    gnumake
    firefox
    slack
    zoom-us
    spotify
    gparted
  ];
}
