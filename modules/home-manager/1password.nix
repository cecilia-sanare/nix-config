{ config, pkgs, lib, libx, ... }:

let
  cfg = config.dotfiles.apps."1password";
  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (types) nullOr;
in
{
  options.dotfiles.apps."1password" = {
    enable = mkEnableOption "1password support";
    publicKey = mkOption {
      description = "Your public GPG Key";
      type =nullOr(types.str);
    };
  };

  config = mkIf (cfg.enable) {
    programs.git = mkIf (config.programs.git.enable) {
      extraConfig = {
        commit.gpgsign = true;
        user.signingkey = cfg.publicKey;

        gpg = {
          format = "ssh";
          ssh.program = if libx.isDarwin then 
            "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
          else "${pkgs._1password-gui}/bin/op-ssh-sign";
        };
      };
    };

    programs.ssh = mkIf (config.programs.ssh.enable) {
      forwardAgent = true;
      extraConfig = if libx.isDarwin then 
        "IdentityAgent ~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      else "IdentityAgent ~/.1password/agent.sock";
    };
  };
}
