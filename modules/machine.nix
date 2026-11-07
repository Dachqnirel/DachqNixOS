# Описание железа конкретного ноутбука.
# Значения задаются в hosts/<имя>/default.nix, а общие модули
# (графика, niri, fastfetch) подстраиваются под них сами.
{ lib, ... }:

{
  options.machine = {
    igpu = lib.mkOption {
      type = lib.types.enum [
        "intel"
        "amd"
      ];
      default = "intel";
      description = "Встроенная графика: от неё зависит драйвер аппаратного видео.";
    };

    nvidia.enable = lib.mkEnableOption "гибридную графику NVIDIA (PRIME offload)";

    display = {
      output = lib.mkOption {
        type = lib.types.str;
        default = "eDP-1";
        description = "Имя встроенного экрана (`niri msg outputs`).";
      };
      scale = lib.mkOption {
        type = lib.types.float;
        default = 1.0;
        description = "Масштаб встроенного экрана: 1.0 = 100%, 1.25 = 125%.";
      };
    };

    gpuLabel = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Подпись видеокарты в fastfetch. Пусто — fastfetch определит сам.";
    };
  };
}
