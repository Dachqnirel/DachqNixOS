# ─────────────────────────────────────────────────────────────────────
#  Машинный минимализм — единая палитра для всей системы.
#  Основа: Base16 Default Dark (Chris Kempson), как у flowing-abyss.
#  90% графита, красный — только для главного, бронза — для мелочей.
#
#  Меняешь цвет здесь → после nixos-rebuild меняется везде:
#  niri, Noctalia, foot, fastfetch, neovim, Dolphin/Qt, GTK, консоль, вход.
# ─────────────────────────────────────────────────────────────────────
rec {
  name = "Machine";

  # Цвета без «#» (так их ждут консоль, foot и KDE)
  base00 = "181818"; # фон
  base01 = "282828"; # панели, карточки
  base02 = "383838"; # выделение, неактивные рамки
  base03 = "585858"; # комментарии, второстепенное
  base04 = "b8b8b8"; # подписи
  base05 = "d8d8d8"; # основной текст
  base06 = "e8e8e8";
  base07 = "f8f8f8"; # самый светлый
  base08 = "ab4642"; # красный — главный акцент (TrackPoint, Блад Энджелс)
  base09 = "dc9656"; # оранжевый — предупреждения
  base0A = "f7ca88"; # жёлтый
  base0B = "a1b56c"; # зелёный
  base0C = "86c1b9"; # бирюзовый
  base0D = "7cafc2"; # холодный синий — ссылки, активные элементы
  base0E = "ba8baf"; # фиолетовый
  base0F = "a16946"; # бронза — второй акцент (Механикус)

  deep = "101010"; # глубже фона: обзор рабочих столов
  mid = "202020"; # между base00 и base01: заголовки, боковые панели

  # Те же цвета с «#» — для niri, CSS, Noctalia
  hex = builtins.mapAttrs (_: v: "#" + v) {
    inherit
      base00 base01 base02 base03 base04 base05 base06 base07
      base08 base09 base0A base0B base0C base0D base0E base0F
      deep mid
      ;
  };

  # Те же цвета как «r,g,b» — для схемы цветов KDE
  rgb = {
    base00 = "24,24,24";
    base01 = "40,40,40";
    base02 = "56,56,56";
    base03 = "88,88,88";
    base04 = "184,184,184";
    base05 = "216,216,216";
    base06 = "232,232,232";
    base07 = "248,248,248";
    base08 = "171,70,66";
    base09 = "220,150,86";
    base0A = "247,202,136";
    base0B = "161,181,108";
    base0C = "134,193,185";
    base0D = "124,175,194";
    base0E = "186,139,175";
    base0F = "161,105,70";
    deep = "16,16,16";
    mid = "32,32,32";
  };

  # 16 цветов терминала в стандартном порядке base16:
  # чёрный, красный, зелёный, жёлтый, синий, фиолетовый, бирюзовый, белый — и яркие
  ansi = [
    base00 base08 base0B base0A base0D base0E base0C base05
    base03 base08 base0B base0A base0D base0E base0C base07
  ];

  font = {
    sans = "IBM Plex Sans";
    serif = "IBM Plex Serif";
    mono = "BlexMono Nerd Font"; # IBM Plex Mono с иконками Nerd Font
    size = 10;
    termSize = 11;
  };

  # Скругление окон в пикселях: 0 — чистый брутализм, 6 — как у ThinkPad
  radius = 6;
}
