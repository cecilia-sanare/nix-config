{
  pkgs,
  config,
  lib,
  ...
}:
with pkgs;
with lib;
with builtins; let
  cfg = config.sys;
in {
  options.sys.hardware.audio = mkOption {
    type = types.nullOr (types.enum ["pulseaudio" "pipewire"]);
    default = "pipewire";
    description = "Audio server to use";
  };

  config = mkIf (cfg.hardware.audio != null) {
    environment.systemPackages = [
      # Need pulseaudio cli tools for pipewire.
      (mkIf (cfg.hardware.audio == "pipewire") pulseaudio)
    ];

    security.rtkit.enable = true;

    services.pipewire = mkIf (cfg.hardware.audio == "pipewire") {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    sound.enable = cfg.hardware.audio == "pulseaudio";
    hardware.pulseaudio = {
      enable = cfg.hardware.audio == "pulseaudio";
      support32Bit = true;
      package = pulseaudioFull;
    };
  };
}

