# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ config, pkgs, ... }: {
  imports = [
    ../../../mixins/home-manager/ssh
    ../../../mixins/home-manager/git
    ../../../mixins/home-manager/apps/discord.nix
    ../../../mixins/home-manager/presets/gaming.nix
  ];

  home.shellAliases = {
    "code" = "codium";
  };

  home.packages = with pkgs; [
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

  programs.git = {
    userName = "Cecilia Sanare";
    userEmail = "admin@sanare.dev";
  };

  dotfiles.desktop = {
    enable = true;
    background = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
  };

  dotfiles.apps.vscodium = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      hashicorp.terraform
      esbenp.prettier-vscode
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
