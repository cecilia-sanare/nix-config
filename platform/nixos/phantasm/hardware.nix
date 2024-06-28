{ inputs, config, lib, ... }:

{
  imports = [
    "${inputs.hardware}/common/pc/ssd/default.nix"
    "${inputs.hardware}/common/cpu/intel"
  ];

  dotfiles.drivers.nvidia.enable = true;
  dotfiles.drivers.nvidia.nvk.enable = true;

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  # boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cdbe1aa0-6677-4908-bdb4-b0c9b1905ae7";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F7B8-5E27";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/02f0a0ba-0022-48d6-a283-43074ada8681";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
