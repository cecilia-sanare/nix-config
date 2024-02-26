{ lib, config, pkgs, ... }: 

with lib;

let
  cfg = config.dotfiles.packages.git;
in {
  options.dotfiles.packages.git = {
    enable = mkEnableOption "Enable the git package";

    name = mkOption {
      description = "The name to sign your commits with (defaults to user.name)";
      type = types.str;
    };

    email = mkOption {
      description = "The email to sign your commits with";
      type = types.str;
    };

    aliases = mkOption {
      description = "Your git aliases";
      type = nullOr(attrsOf(types.str));
    };

    agent = mkOption {
      description = "Specify an agent to automatically setup";
      type = nullOr(types.enum(["1password"]));
    };

    gpg = {
      enable = mkOption {
        description = "Whether commits should be signed via gpg";
        type = types.bool;
      };

      publicKey = mkOption {
        description = "The public signing key";
        type = types.str;
      };
    };
  };

  config = mkIf (cfg.enable) {
    home-manager.sharedModules = [{
      programs.git = {
        enable = true;
        userName = cfg.name;
        userEmail = cfg.email;

        aliases = cfg.aliases;

        extraConfig = mkMerge [
          {
            init.defaultBranch = "main";
            push.autoSetupRemote = true;

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
          }
          # GPG Configuration
          (mkIf(cfg.gpg.enable) {
            commit.gpgsign = true;
            user.signingkey = cfg.gpg.publicKey;

            gpg = mkIf(cfg.agent == "1password") {
              format = "ssh";
              ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
            };
          })
        ];
      };

      programs.ssh = {
        enable = true;
        forwardAgent = cfg.agent != null;
        extraConfig = mkIf (cfg.agent == "1password") "IdentityAgent ~/.1password/agent.sock";
      };
    }];
  };
}
