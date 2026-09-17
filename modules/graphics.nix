{ config, pkgs, ... }:

{
  # Enable graphics support (OpenGL)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Force the use of the proprietary NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Required parameter for correct Wayland operation
    modesetting.enable = true;

    # Use proprietary driver (open = false)
    open = false;

    # Install NVIDIA Settings control panel
    nvidiaSettings = true;

    # Select stable driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure hybrid graphics (NVIDIA Optimus / Prime)
  hardware.nvidia.prime = {
    # Offload mode: saves battery by using NVIDIA only on demand
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # The exact bus IDs of your GPUs (obtained from lspci)
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # 1. Restore fonts to prevent text and icons from disappearing
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
  ];

  # 2. Fix for proper rendering of Firefox windows under Wayland
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "0";
  };
}
