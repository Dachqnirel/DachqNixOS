# Гибридная графика Intel + NVIDIA (Optimus / PRIME offload)
{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # для Steam / Wine
    extraPackages = [ pkgs.intel-media-driver ]; # аппаратное видео на Intel
  };

  # Видео (YouTube и т.п.) декодирует Intel, а не CPU
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # Драйвер NVIDIA. Строка нужна и без X-сервера: по ней NixOS ставит драйвер
  services.xserver.videoDrivers = [ "nvidia" ];

  # Раньше эти модули загружал X-сервер экрана входа SDDM.
  # Экран входа теперь без X, поэтому грузим их сами — иначе дискретка
  # не будет видна программам, запущенным через nvidia-offload.
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
  ];

  hardware.nvidia = {
    modesetting.enable = true; # обязательно для Wayland
    open = false; # проприетарный драйвер
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement = {
      enable = true; # корректный сон и пробуждение
      finegrained = true; # дискретка выключается, когда не нужна
    };

    # Offload: по умолчанию работает Intel, NVIDIA — по запросу.
    # Запуск на дискретке: `nvidia-offload <программа>`
    # intelBusId / nvidiaBusId — в configuration.nix
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
