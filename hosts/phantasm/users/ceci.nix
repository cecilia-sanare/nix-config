# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ config, lib, pkgs, platform, vscode-extensions, ... }:

let
  stable-packages = with pkgs; [
    vlc
    firefox
    slack
    zoom-us
    spotify
    figma-linux
    obs-studio
    rustdesk # Teamviewer alternative
    caprine-bin # Facebook Messenger App
    heroic
    protontricks
    xivlauncher
    smart-open
  ];

  unstable-packages = with pkgs.unstable; [
    tuba
  ];
in
{
  imports = [
    ../../../mixins/home-manager/ssh
    ../../../mixins/home-manager/git
    ../../../mixins/home-manager/apps/discord.nix
    ../../../mixins/home-manager/presets/gaming.nix
  ];

  home.shellAliases = {
    "so" = "smart-open";
  };

  home.packages = stable-packages ++ unstable-packages;

  programs.git = {
    userName = "Cecilia Sanare";
    userEmail = "ceci@sanare.dev";
  };

  dotfiles.desktop = {
    enable = true;
    background = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";

    favorites = [
      "org.gnome.Nautilus.desktop"
      "firefox.desktop"
      "codium.desktop"
      "discord.desktop"
    ];

    cursor = {
      enable = true;
      url = "https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur.tar.gz";
      hash = "sha256-VZWFf1AHum2xDJPMZrBmcyVrrmYGKwCdXOPATw7myOA=";
      name = "macOS-BigSur";
    };

    picture = {
      url = "https://avatars.githubusercontent.com/u/9692284?v=4";
      sha256 = "11gdxhgk9xqfh1936vg3gq3nqqj0d6fwgpc3zzh5c64y94g96vaj";
    };
  };
}
