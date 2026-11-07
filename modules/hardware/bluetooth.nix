{
  imports = [ ./logitech.nix ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
