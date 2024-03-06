{ lib, config, ... }:

with lib;

let
  cfg = config.dotfiles.apps.goxlr;
in
{
  options.dotfiles.apps.goxlr = with types; {
    enable = mkEnableOption "Enable goxlr support";

    profile = mkOption {
      description = "The path to the GoXLR profile you wish to load";
      type = types.path;
    };

    micProfile = mkOption {
      description = "The path to the GoXLR mic profile you wish to load";
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    services.goxlr-utility = {
      enable = true;
      autoStart.xdg = true;
    };

    home-manager.sharedModules = [
      ({ config, ... }: {
        home.file.".config/goxlr-utility/settings.json".text = ''
          {
            "show_tray_icon": true,
            "tts_enabled": false,
            "allow_network_access": false,
            "profile_directory": "${config.home.homeDirectory}/.local/share/goxlr-utility/profiles",
            "mic_profile_directory": "${config.home.homeDirectory}/.local/share/goxlr-utility/mic-profiles",
            "samples_directory": "${config.home.homeDirectory}/.local/share/goxlr-utility/samples",
            "presets_directory": "${config.home.homeDirectory}/.local/share/goxlr-utility/presets",
            "icons_directory": "${config.home.homeDirectory}/.local/share/goxlr-utility/icons",
            "logs_directory": "${config.home.homeDirectory}/.local/share/goxlr-utility/logs",
            "log_level": "Debug",
            "activate": null,
            "devices": {
              "S210312461DI7": {
                "profile": "Default",
                "mic_profile": "DEFAULT",
                "hold_delay": 500,
                "sampler_pre_buffer": null,
                "chat_mute_mutes_mic_to_chat": true,
                "lock_faders": false,
                "enable_monitor_with_fx": false,
                "shutdown_commands": [
                  {
                    "SaveProfile": []
                  },
                  {
                    "SaveMicProfile": []
                  }
                ]
              }
            }
          }
        '';

        home.file.".local/share/goxlr-utility/profiles/Default.goxlr".source = cfg.profile;
        home.file.".local/share/goxlr-utility/mic-profiles/DEFAULT.goxlrMicProfile".source = cfg.micProfile;
      })
    ];
  };
}
