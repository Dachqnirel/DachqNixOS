# Встроенная графика и аппаратное видео — для любого ноутбука
{
  config,
  lib,
  pkgs,
  ...
}:

let
  intel = config.machine.igpu == "intel";
in
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # для Steam / Wine
    # Intel: отдельный драйвер видео; AMD работает из коробки (mesa)
    extraPackages = lib.optionals intel [ pkgs.intel-media-driver ];
  };

  # Видео (YouTube и т.п.) декодирует встроенная графика, а не CPU
  environment.sessionVariables.LIBVA_DRIVER_NAME = if intel then "iHD" else "radeonsi";
}
