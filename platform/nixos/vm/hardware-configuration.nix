{ inputs, ... }:

{
  imports = [
    "${inputs.hardware}/common/pc/ssd/default.nix"
  ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
