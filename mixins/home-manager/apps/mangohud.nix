{ pkgs, lib, libx, ... }:
let
  inherit (lib) mkIf;
in
mkIf libx.isLinux {
  home = {
    packages = with pkgs; [
      mangohud
    ];

    file."./.config/MangoHud/MangoHud.conf".text = ''
      # See for example: https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf

      gpu_stats
      cpu_stats
      fps
      frametime
      vulkan_driver
      throttling_status
      gpu_name
      frame_timing
      mangoapp_steam
      text_outline
      no_display
      round_corners=5
    '';
  };
}
