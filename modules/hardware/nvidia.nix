# Гибридная графика Intel + NVIDIA (Optimus / PRIME offload)
{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;                            # для Steam / Wine
    extraPackages = [ pkgs.intel-media-driver ];   # аппаратное видео на Intel
  };

  # Видео (YouTube и т.п.) декодирует Intel, а не CPU
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;    # обязательно для Wayland
    open = false;                 # проприетарный драйвер
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement = {
      enable = true;       # корректный сон и пробуждение
      finegrained = true;  # дискретка выключается, когда не нужна
    };

    # Offload: по умолчанию работает Intel, NVIDIA — по запросу.
    # Запуск на дискретке: `nvidia-offload <программа>`
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
