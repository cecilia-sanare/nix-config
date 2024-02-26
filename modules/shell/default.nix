{ lib, config, pkgs, ... }: 

with lib;

let
  cfg = config.dotfiles.shell;
in {
  options.dotfiles.shell = with types; {
    enable = mkEnableOption "Enable the shell configuration";

    type = mkOption {
      description = "The shell to enable for this user";
      type = types.enum(["bash" "zsh"]);
      default = "zsh";
    };

    aliases = mkOption {
      description = "The shell aliases for this user";
      type = nullOr(attrsOf(types.str));
      default = null;
    };

    ohMyZsh = {
      enable = mkEnableOption "Enable the ohMyZsh configuration";

      plugins = mkOption {
        type = listOf(types.str);
        default = ["git" "sudo" "docker"];
      };

      theme = mkOption {
        type = types.str;
        default = "robbyrussell";
      };
    };
  };

  config = let
    bash = cfg.type == "bash";
    zsh = cfg.type == "zsh";
  in mkIf (cfg.enable) {
    users.defaultUserShell = pkgs.${cfg.type};
    programs.${cfg.type}.enable = true;

    home-manager.sharedModules = [{
      programs.zsh = mkIf(zsh) {
        enable = true;
        oh-my-zsh = mkIf (cfg.ohMyZsh.enable) {
          enable = true;
          plugins = cfg.ohMyZsh.plugins;
          theme = cfg.ohMyZsh.theme;
        };
      };
      
      home.shellAliases = cfg.aliases;
    }];
  };
}
