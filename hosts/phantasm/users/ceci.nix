# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ config, lib, pkgs, platform, vscode-extensions, ... }:

let
  stable-packages = with pkgs.stable; [
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
  ];

  unstable-packages = with pkgs; [
    tuba
    smart-open
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
      # "org.gnome.Nautilus.desktop"
      "firefox.desktop"
      "codium.desktop"
      "discord.desktop"
    ];

    picture = {
      url = "https://avatars.githubusercontent.com/u/9692284?v=4";
      sha256 = "11gdxhgk9xqfh1936vg3gq3nqqj0d6fwgpc3zzh5c64y94g96vaj";
    };
  };
}
