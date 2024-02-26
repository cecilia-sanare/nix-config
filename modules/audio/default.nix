{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.dotfiles.audio;
  json = pkgs.formats.json { };
in
{
  options.dotfiles.audio = {
    enable = mkEnableOption "Enable the audio configurations";

    alerts = mkEnableOption "alert bell";

    server = mkOption {
      type = types.nullOr (types.enum [ "pulseaudio" "pipewire" ]);
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

  config =
    let
      pipewire = cfg.server == "pipewire";
      pulseaudio = cfg.server == "pulseaudio";
      disableAlerts = !cfg.alerts;
    in
    mkIf (cfg.enable) {
      environment.systemPackages = [
        # Need pulseaudio cli tools for pipewire.
        (mkIf (pipewire) pkgs.pulseaudio)
      ];

      security.rtkit.enable = true;

      services.pipewire = mkIf (pipewire) {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;

        # TODO: Use this one stable has this functionality
        # extraConfig = {
        #   pipewire = {
        #     "99-silent-bell" = {
        #       "context.properties" = {
        #           "module.x11.bell" = false ;
        #       };
        #     };
        #   };
        # };
      };

      # Disable the bell noises
      environment.etc = mkIf (disableAlerts) {
        "pipewire/pipewire.conf.d/99-silent-bell.conf".source = json.generate "99-silent-bell.conf" {
          "context.properties" = {
            "module.x11.bell" = false;
          };
        };
      };

      sound.enable = pulseaudio;
      hardware.pulseaudio = {
        enable = pulseaudio;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
      };

      services.goxlr-utility.enable = cfg.goxlr.enable;

      home-manager.sharedModules = [
        (mkIf (disableAlerts) {
          dconf.settings = {
            "org/gnome/desktop/sound" = {
              event-sounds = false;
              input-feedback-sound = false;
            };
          };
        })
        (mkIf (cfg.goxlr.enable) ({ config, ... }: {
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

          home.file.".local/share/goxlr-utility/profiles/Default.goxlr".source = cfg.goxlr.profile;
          home.file.".local/share/goxlr-utility/mic-profiles/DEFAULT.goxlrMicProfile".source = cfg.goxlr.micProfile;
        }))
      ];
    };
}
