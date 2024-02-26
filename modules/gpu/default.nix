{ lib, config, pkgs, ... }: 

with lib;

let
  cfg = config.dotfiles.gpu;
in {
  options.dotfiles.gpu = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    vendor = mkOption {
      description = "The vendor of the GPU. (amd, intel, or nvidia)";
      # TODO: Setup to work with AMD / Intel GPUs
      type = types.nullOr (types.enum ["nvidia"]);
    };
  };

  config = let
    amd = cfg.vendor == "amd";
    intel = cfg.vendor == "intel";
    nvidia = cfg.vendor == "nvidia";
    xorg = elem "xorg" config.dotfiles.desktop.protocol;
  in mkIf (cfg.enable) {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [
      (mkIf amd "amdgpu")
      (mkIf intel "intel")
      (mkIf nvidia "nvidia")
    ];

    hardware.nvidia = mkIf (nvidia) {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
