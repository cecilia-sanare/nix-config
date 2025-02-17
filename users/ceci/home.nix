# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ pkgs, libx, lib, platform, inputs, ... }:

let
  master-packages = with pkgs.master; libx.getPlatformList {
    "x86_64-linux" = [
      xivlauncher
      fflogs
    ];
  };

  stable-packages = with pkgs.stable; libx.getPlatformList {
    shared = [
      qbittorrent
    ];
    "darwin" = [ ];
    "linux" = [
      solaar
      android-tools
      autokey
    ];
    "x86_64-linux" = [
      signal-desktop
      vesktop
      spotify
      figma-linux
      obs-studio
      tor-browser
      qpwgraph
      heroic
      openmw
      parsec-bin
      gimp
      blender
      mullvad-browser
      pegasus-frontend
      (retroarch.override {
        cores = with libretro; [
          snes9x
          mupen64plus
        ];
      })
      # Retroarch versions don't support retro achieves
      duckstation
      ryujinx
      lutris
      rpcs3
      megasync
      xemu
    ];
    "aarch64-linux" = [
      spot # Spotify Open Source Client that supports ARM
    ];
  };

  unstable-packages = with pkgs; libx.getPlatformList {
    "shared" = [
    ];
    "linux" = [
      smart-open # TODO: This *should* work on macos, but currently doesn't
      godot_4-mono
    ];
    "x86_64-linux" = [
      wineWowPackages.stable
      unityhub
      (prismlauncher.override { 
        jdks = [ 
          temurin-bin-21
          temurin-bin-8
          temurin-bin-17
        ];
      })
      # Retroarch versions don't support retro achieves
      dolphin-emu
    ];
    "aarch64-linux" = [
      vesktop
    ];
  };

  inherit (lib) mkIf;
in
{
  imports = [
    ../../mixins/home-manager/ssh
    ../../mixins/home-manager/presets/gaming.nix
    ../../mixins/home-manager/apps/firefox.nix
  ];

  home.shellAliases = {
    "so" = "smart-open";
  };

  services.protontweaks.config = mkIf(platform == "x86_64-linux") {
    gamemode = true;
    mangohud = true;
  };

  home.packages = stable-packages ++ unstable-packages ++ master-packages;

  programs.git = {
    enable = true;
    userName = "Cecilia Sanare";
    userEmail = "ceci@sanare.dev";

    aliases = {
      cp = "cherry-pick";
      st = "status -s";
      cl = "clone";
      ci = "commit";
      co = "checkout";
      br = "branch";
      diff = "diff --word-diff";
      dc = "diff --cached";
      ca = "commit --amend --no-edit";
    };

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.ff = "only";
      merge.ff = false;

      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        ui = "auto";
      };

      core = {
        excludesfile = "~/.gitignore";
        editor = "vim";
      };

      help = {
        autocorrect = 1;
      };

      push = {
        default = "simple";
      };
    };
  };

  programs.firefox.profiles.ceci.bookmarks = [
    {
      name = "Toolbar";
      toolbar = true;
      bookmarks = [
        {
          name = "Work";
          bookmarks = [
            {
              name = "Jumpcloud";
              url = "https://console.jumpcloud.com";
            }
            {
              name = "Timesheets";
              url = "https://c36.qbo.intuit.com/qbo36/login/";
            }
          ];
        }
        {
          name = "";
          tags = [ "git" "sourcecode" ];
          url = "https://github.com/cecilia-sanare";
        }
        {
          name = "";
          tags = [ "git" "sourcecode" ];
          url = "https://gitlab.com";
        }
        {
          name = "";
          tags = [ "youtube" ];
          url = "https://youtube.com";
        }
      ];
    }
  ];

  dotfiles.apps."1password" = {
    enable = true;
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX";
  };

  dotfiles.desktop = {
    enable = true;

    cursor = {
      enable = true;
      url = "https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur.tar.gz";
      hash = "sha256-VZWFf1AHum2xDJPMZrBmcyVrrmYGKwCdXOPATw7myOA=";
      name = "macOS-BigSur";
    };

    favorites = [
      "org.gnome.Nautilus.desktop"
      "firefox.desktop"
      "codium.desktop"
      "vesktop.desktop"
    ];

    picture = {
      url = "https://avatars.githubusercontent.com/u/9692284?v=4";
      sha256 = "11gdxhgk9xqfh1936vg3gq3nqqj0d6fwgpc3zzh5c64y94g96vaj";
    };
  };
}
