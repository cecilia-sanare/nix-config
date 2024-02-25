{ lib, config, ... }: 

{
  options.sys.hardware = {
    goxlr = lib.mkEnableOption "System has a goxlr";
  };

  config = {
    services.goxlr-utility.enable = config.sys.hardware.goxlr;
  };
}