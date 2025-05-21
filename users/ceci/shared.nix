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
      vitest.explorer
      astro-build.astro-vscode
    ];
  };
}
