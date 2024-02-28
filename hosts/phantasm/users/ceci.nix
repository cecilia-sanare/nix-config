# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ config, pkgs, ... }:

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

  unstable-packages = with pkgs.unstable; [ ];
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
    "code" = "codium";
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

  dotfiles.apps.vscodium = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      hashicorp.terraform
      esbenp.prettier-vscode
      arrterian.nix-env-selector
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "EditorConfig";
        publisher = "EditorConfig";
        version = "0.16.4";
        sha256 = "j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
      }
    ];
  };
}
