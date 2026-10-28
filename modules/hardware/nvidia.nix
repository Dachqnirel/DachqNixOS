# Гибридная графика Intel + NVIDIA (Optimus / PRIME offload)
{ config, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;    # для Steam / Wine
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;    # обязательно для Wayland
    open = false;                 # проприетарный драйвер
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Offload: по умолчанию работает Intel, NVIDIA — по запросу.
    # Запуск на дискретке: `nvidia-offload <программа>`
    # intelBusId / nvidiaBusId — в configuration.nix
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
