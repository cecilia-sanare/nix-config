{ lib, config, ... }: 

with lib;

let
  cfg = config.dotfiles.storage;
in {
  options.dotfiles.storage = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    type = mkOption {
      description = "The types of drives in your machine.";
      type = types.enum(["ssd" "hdd" "both"]);
    };
  };

  config = let
    ssd = cfg.type == "ssd";
  in mkIf (cfg.enable) {
    services.udisks2.enable = true;
    services.fstrim.enable = ssd;
  };
}