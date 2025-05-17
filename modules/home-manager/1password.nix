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
      type = nullOr types.str;
    };
  };

  config = mkIf cfg.enable {
    programs.git = mkIf config.programs.git.enable {
      extraConfig = {
        commit.gpgsign = true;
        user.signingkey = cfg.publicKey;

        gpg = {
          format = "ssh";
          ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        };
      };
    };

    programs.ssh = mkIf config.programs.ssh.enable {
      forwardAgent = true;
      extraConfig = "IdentityAgent ~/.1password/agent.sock";
    };
  };
}
