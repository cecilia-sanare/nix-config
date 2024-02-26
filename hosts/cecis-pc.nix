{ config, pkgs, ... }:

{
  # Host config for my desktop

  # Old OS
  fileSystems."/mnt/old" = {
    device = "/dev/nvme0n1p1";
    fsType = "ext4";
  };

  fileSystems."/mnt/media" = {
    device = "/dev/nvme2n1p1";
    fsType = "ext4";
  };

  dotfiles = {
    containers.enable = true;

    desktop = {
      enable = true;
      sleep = false;
      dark = true;
    };

    displays = [
      {
        name = "DP-4";
        fingerprint = "00ffffffffffff0006b307270101010113210104b53c22783b9325ad4f44a9260d5054bfef00714f81809500d1c00101010101010101565e00a0a0a029503020350055502100001c000000fd003090dfdf3b010a202020202020000000fc0056473237415131410a20202020000000ff0052354c4d51533038353431310a0181020327f14c90111213040e0f1d1e1f403f2309070783010000e305e001e6060701737300e2006a9ee80078a0a067500820980455502100001a6fc200a0a0a055503020350055502100001a5aa000a0a0a046503020350055502100001a00000000000000000000000000000000000000000000000000000000000000000000a1";
        primary = true;
        resolution = "2560x1440";
        position = "2560x0";
        rate = "144.01";
      }
      {
        name = "DP-2";
        fingerprint = "00ffffffffffff0006b307270101010134200104b53c22783b9325ad4f44a9260d5054bfef00714f81809500d1c00101010101010101565e00a0a0a029503020350055502100001c000000fd003090dfdf3b010a202020202020000000fc0056473237415131410a20202020000000ff004e434c4d51533034353936300a0152020327f14c90111213040e0f1d1e1f403f2309070783010000e305e001e6060701737300e2006a9ee80078a0a067500820980455502100001a6fc200a0a0a055503020350055502100001a5aa000a0a0a046503020350055502100001a00000000000000000000000000000000000000000000000000000000000000000000a1";
        primary = false;
        resolution = "2560x1440";
        position = "0x0";
        rate = "144.01";
      } 
    ];

    audio = {
      enable = true;
      goxlr = {
        enable = true;
        profile = ./configs/Default.goxlr;
        micProfile = ./configs/DEFAULT.goxlrMicProfile;
      };
    };

    storage = {
      enable = true;
      type = "ssd";
    };

    network = {
      enable = true;
      printing = true;
      hostName = "cecis-pc";
    };

    gpu = {
      enable = true;
      vendor = "nvidia";
    };

    shell = {
      enable = true;
      ohMyZsh.enable = true;

      aliases = {
        code = "codium";
      };
    };

    packages = {
      git = {
        enable = true;
        agent = "1password";
        name = "Cecilia Sanare";
        email = "ceci@sanare.dev";

        gpg = {
          enable = true;
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX";
        };

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
      };

      vscodium = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          hashicorp.terraform
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "EditorConfig";
            publisher = "EditorConfig";
            version = "0.16.4";
            sha256 = "j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
          }
        ];
      };
    };
  };

  dotfiles.users = {
    default = {
      background = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";

      extensions = with pkgs; [
        gnomeExtensions.hide-activities-button
        gnomeExtensions.just-perfection
        gnomeExtensions.dash-to-dock
        gnomeExtensions.appindicator
      ];

      dconf = {
        "org/gnome/shell/extensions/dash-to-dock" = {
          click-action = "minimize-or-previews";
          show-trash = false;
          show-show-apps-button = false;
          dash-max-icon-size = 80;
          multi-monitor = true;
        };
      };

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

      stateVersion = "23.11";
    };

    ceci = {
      name = "Cecilia Sanare";
      sudoer = true;
    };
  };
}