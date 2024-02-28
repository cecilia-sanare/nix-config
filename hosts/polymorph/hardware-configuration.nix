{ inputs, ... }:

{
  imports = [
    "${inputs.hardware}/common/pc/ssd"
  ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
