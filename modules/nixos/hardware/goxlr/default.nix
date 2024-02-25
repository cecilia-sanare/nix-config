{ lib, config, ... }: 

{
  options.sys.hardware = {
    goxlr = lib.mkEnableOption "System has a goxlr";
  };

  config = {
    # TODO: Figure out how to automate the goxlr config setup
    services.goxlr-utility.enable = config.sys.hardware.goxlr;

    home-manager.sharedModules = [{
      home = {
        file.goxlr-settings = {
          enable = true;
          source = ./settings.json;
          target = "./.config/goxlr-utility/settings.json";
        };

        file.goxlr-profile = {
          enable = true;
          source = ./Default.goxlr;
          target = "./.local/share/goxlr-utility/profiles/Default.goxlr";
        };

        file.goxlr-mic-profile = {
          enable = true;
          source = ./DEFAULT.goxlrMicProfile;
          target = "./.local/share/goxlr-utility/mic-profiles/DEFAULT.goxlrMicProfile";
        };
      };
    }];
  };
}