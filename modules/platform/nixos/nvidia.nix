{ inputs, lib, config, pkgs, ... }:

let
  cfg = config.dotfiles.drivers;
  isNvidia = cfg.nvidia == "nvidia";
  isMesa = cfg.nvidia == "mesa";

  inherit (lib) mkEnableOption mkOption mkIf types mkMerge;
  inherit (types) nullOr;
in
{
  options.dotfiles.drivers.nvidia = mkOption {
    description = "Enable nvidia gpu support with the given driver";
    type = nullOr(types.enum(["nvidia" "mesa"]));
    default = null;
  };

  config = mkMerge [
    (mkIf (isNvidia) {
      services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
      hardware.opengl.extraPackages = with pkgs; [
        vaapiVdpau
      ];

      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
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
    })
    # NOTE: Still a WIP, not currently working
    (mkIf (isMesa) {
      # Current LTS Kernel
      boot.kernelPackages = pkgs.linuxPackages;
      
      # Enable Nvidia drivers
      boot.blacklistedKernelModules = [ "nvidia" "nvidia_uvm" ];
      boot.initrd.kernelModules = [ "nouveau" ];
      boot.kernelParams = [
        "nouveau.config=NvGspRm=1"
        "nouveau.debug=info,VBIOS=info,gsp=debug"
      ];
      services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
      hardware.opengl.package = pkgs.mesa.drivers;
    })
  ];
}
