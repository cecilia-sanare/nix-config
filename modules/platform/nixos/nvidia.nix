{ lib, config, pkgs, ... }:

let
  cfg = config.dotfiles.drivers.nvidia;
  usingNvidia = lib.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  options.dotfiles.drivers.nvidia = {
    enable = lib.mkEnableOption "NVIDIA drivers";
    nvk.enable = lib.mkEnableOption "NVK specialisation";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      boot.kernelParams = lib.optional usingNvidia "nvidia_drm.fbdev=1";

      services.xserver.videoDrivers = ["nvidia"];

      hardware = {
        opengl.extraPackages = [pkgs.vaapiVdpau];
        nvidia = {
          package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
          modesetting.enable = true;
          forceFullCompositionPipeline = true;

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
        };
      };
    }

    (lib.mkIf cfg.nvk.enable {
      specialisation = {
        nvk.configuration = {
          boot = {
            kernelParams = ["nouveau.config=NvGspRm=1"];
            initrd.kernelModules = ["nouveau"];
          };

          environment.sessionVariables = {
            MESA_VK_VERSION_OVERRIDE = "1.3";
          };

          hardware.opengl.extraPackages = lib.mkForce [];

          services.xserver.videoDrivers = lib.mkForce ["modesetting"];

          system.nixos.tags = ["with-nvk"];
        };
      };
    })
  ]);
}
