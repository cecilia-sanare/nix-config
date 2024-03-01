# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, users, config, pkgs, vscode-extensions, ... }: {
  imports = [
    ../../mixins/nixos/desktop/settings/no-sleep
    ../../mixins/nixos/desktop/settings/no-alerts
    ../../mixins/nixos/containers/podman/unstable.nix
    ../../mixins/nixos/shells/fish
    ../../mixins/nixos/presets/gaming.nix
    # ../../mixins/nixos/apps/runescape.nix
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 8080 ];

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.ceci.description = "Cecilia Sanare";
  users.users.ceci.hashedPassword = "$6$P9EJMHnu8b/OVVRS$1qECnQmYav5EhbnTOk3mnO3dBlMOAsF9/lgCRONwO/GHUfHZFIpxYSyOTPqpv6S6dqO4uSxSZ9KMDl5yX9AHH1";
  # users.users.ceci.initialPassword = null;

  dotfiles.displays = [
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

  # TODO: Figure out if we can somehow get this at a per user level
  dotfiles.apps."1password" = {
    inherit users;

    enable = true;
    agent = {
      enable = true;
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX";
    };
  };

  # TODO: Figure out if we can somehow get this at a per user level
  dotfiles.apps.goxlr = {
    enable = true;
    profile = ./configs/Default.goxlr;
    micProfile = ./configs/DEFAULT.goxlrMicProfile;
  };

  environment.systemPackages = [
    pkgs.dotnet-sdk_8
  ];

  dotfiles.apps.vscode = {
    enable = true;
    extensions = with vscode-extensions.open-vsx; [
      arrterian.nix-env-selector
      jnoortheen.nix-ide
      oven.bun-vscode
      rust-lang.rust-analyzer
      esbenp.prettier-vscode
      editorconfig.editorconfig
      dbaeumer.vscode-eslint
      tamasfe.even-better-toml
      bradlc.vscode-tailwindcss
    ] ++ (with pkgs.vscode-extensions; [
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "csharp";
          publisher = "ms-dotnettools";
          version = "2.15.30";
          sha256 = "sha256-i5shbpjp0e0qUIG6FLPu1mIN0DD2+zdCq/nZa49v5iI=";
          arch = "linux-x64";
        };

        postPatch = ''
          sed -i -E -e 's_uname -m_${pkgs.coreutils}/bin/uname -m_g' "$PWD/dist/extension.js"

          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc ]}:\$ORIGIN" \
            "./.roslyn/Microsoft.CodeAnalysis.LanguageServer"
        '';
      })
    ]) ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-dotnet-runtime";
        publisher = "ms-dotnettools";
        version = "2.0.2";
        sha256 = "sha256-7Nx8OiXA5nWRcpFSAqBWmwSwwNLSYvw5DEC5Q3qdDgU=";
      }
    ]);
  };
}
