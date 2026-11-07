# Гибридная графика + NVIDIA (Optimus / PRIME offload).
# Включается в hosts/<имя>/default.nix: machine.nvidia.enable = true;
# Там же — адреса видеокарт hardware.nvidia.prime.*BusId (из `lspci`).
{ config, lib, ... }:

lib.mkIf config.machine.nvidia.enable {
  # Драйвер NVIDIA. Строка нужна и без X-сервера: по ней NixOS ставит драйвер
  services.xserver.videoDrivers = [ "nvidia" ];

  # Экран входа работает без X-сервера, поэтому модули грузим сами —
  # иначе дискретка не будет видна программам через nvidia-offload.
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

    # Offload: по умолчанию работает встроенная графика, NVIDIA — по запросу.
    # Запуск на дискретке: `nvidia-offload <программа>`
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
