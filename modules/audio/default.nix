{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.dotfiles.audio;
in {
  options.dotfiles.audio = {
    enable = mkEnableOption "Enable the audio configurations";

    server = mkOption {
      type = types.nullOr (types.enum ["pulseaudio" "pipewire"]);
      default = "pipewire";
      description = "Audio server to use";
    };

    goxlr = {
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
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [
      # Need pulseaudio cli tools for pipewire.
      (mkIf (cfg.server == "pipewire") pkgs.pulseaudio)
    ];

    security.rtkit.enable = true;

    services.pipewire = mkIf (cfg.server == "pipewire") {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    sound.enable = cfg.server == "pulseaudio";
    hardware.pulseaudio = {
      enable = cfg.server == "pulseaudio";
      support32Bit = true;
      package = pkgs.pulseaudioFull;
    };

    services.goxlr-utility.enable = cfg.goxlr.enable;

    home-manager.sharedModules = mkIf(cfg.goxlr.enable) [{
      home = {
        file.goxlr-settings = {
          enable = true;
          text = 
          ''
          {
            "show_tray_icon": true,
            "tts_enabled": false,
            "allow_network_access": false,
            "profile_directory": "~/.local/share/goxlr-utility/profiles",
            "mic_profile_directory": "~/.local/share/goxlr-utility/mic-profiles",
            "samples_directory": "~/.local/share/goxlr-utility/samples",
            "presets_directory": "~/.local/share/goxlr-utility/presets",
            "icons_directory": "~/.local/share/goxlr-utility/icons",
            "logs_directory": "~/.local/share/goxlr-utility/logs",
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
          target = "./.config/goxlr-utility/settings.json";
        };

        file.goxlr-profile = {
          enable = true;
          source = cfg.goxlr.profile;
          target = "./.local/share/goxlr-utility/profiles/Default.goxlr";
        };

        file.goxlr-mic-profile = {
          enable = true;
          source = cfg.goxlr.micProfile;
          target = "./.local/share/goxlr-utility/mic-profiles/DEFAULT.goxlrMicProfile";
        };
      };
    }];
  };
}