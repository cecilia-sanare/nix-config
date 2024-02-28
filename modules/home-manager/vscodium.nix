{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles.apps.vscodium;
  package = if cfg.latest then pkgs.unstable.vscodium else pkgs.vscodium;
in
{
  options.dotfiles.apps.vscodium = with types; {
    enable = mkEnableOption "vscodium package";

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
    programs.vscode = {
      enable = true;
      package = package;
      extensions = cfg.extensions;
      userSettings = mkIf (cfg.settings != null) cfg.settings;
    };
  };
}
