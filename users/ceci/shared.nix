# Default Shared Configuration
{ username, vscode-extensions, pkgs, lib, libx, ... }:

{
  users.users.${username} = {
    description = "Cecilia Sanare";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX" ];
  };

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
      hashicorp.terraform
      kelvin.vscode-sshfs
      redhat.java
      vue.volar
    ]
    ++ lib.optionals libx.isLinux [
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
    ]
    ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-dotnet-runtime";
        publisher = "ms-dotnettools";
        version = "2.0.2";
        sha256 = "sha256-7Nx8OiXA5nWRcpFSAqBWmwSwwNLSYvw5DEC5Q3qdDgU=";
      }
      {
        name = "vscode-nushell-lang";
        publisher = "TheNuProjectContributors";
        version = "1.8.0";
        sha256 = "sha256-Si7N50vonpG79lPingGZiNAZjeoRJ45PDuolnR9a9tY=";
      }
    ]);
  };
}
