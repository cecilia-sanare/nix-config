{ lib, config, ... }: 

{
  options.sys.hardware = {
    goxlr = lib.mkEnableOption "System has a goxlr";
  };

  config = {
    # TODO: Figure out how to automate the goxlr config setup
    services.goxlr-utility.enable = config.sys.hardware.goxlr;
  };
}