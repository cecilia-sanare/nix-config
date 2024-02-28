{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles.apps.vscode;
in
{
  options.dotfiles.apps.vscode = with types; {
    enable = mkEnableOption "vscode";

    latest = mkEnableOption "latest release";

    extensions = mkOption {
      description = "The extensions you'd like to enable";
      type = listOf (types.package);
      default = [ ];
    };

    settings = mkOption {
      description = "The extensions you'd like to enable";
      type = nullOr (attrsOf (types.anything));
      default = null;
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = cfg.extensions;
      })
    ];
  };
}
