{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles.apps.vscode;
  package = {
    inherit (pkgs) vscode vscodium;
  }.${if cfg.open-source then "vscodium" else "vscode"};
in
{
  options.dotfiles.apps.vscode = with types; {
    enable = mkEnableOption "vscode";

    open-source = mkEnableOption "vscodium" // {
      default = true;
    };

    package = mkOption {
      description = "The package to use";
      type = types.package;
      default = package;
    };

    extensions = mkOption {
      description = "The extensions you'd like to enable";
      type = listOf types.package;
      default = [ ];
    };

    settings = mkOption {
      description = "The extensions you'd like to enable";
      type = nullOr (attrsOf types.anything);
      default = null;
    };
  };

  config = mkIf cfg.enable {
    environment.shellAliases = mkIf(cfg.open-source) {
      code = "codium";
    };

    environment.systemPackages = with pkgs; [
      (vscode-with-extensions.override {
        vscode = cfg.package;
        vscodeExtensions = cfg.extensions;
      })
    ];
  };
}
