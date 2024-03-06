{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.dotfiles.apps."1password";
in
{
  options.dotfiles.apps."1password" = {
    enable = mkEnableOption "1password";
    agent = {
      enable = mkEnableOption "agent support";
      publicKey = mkOption {
        description = "Your public GPG Key";
        type = types.str;
      };
    };
    users = mkOption {
      description = "The users to set as policy owners";
      type = listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      _1password
      _1password-gui
    ];

    programs = {
      _1password.enable = true;
      _1password-gui = {
        package = pkgs._1password-gui;
        enable = true;
        polkitPolicyOwners = [ "ceci" ];
      };
    };

    home-manager.sharedModules = mkIf cfg.agent.enable [
      ({ config, ... }: {
        programs.git = mkIf config.programs.git.enable {
          extraConfig = {
            commit.gpgsign = true;
            user.signingkey = cfg.agent.publicKey;

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
      })
    ];
  };
}
