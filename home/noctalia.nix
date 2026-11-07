# Noctalia: палитра, шрифт, плоская панель, экран блокировки.
# Это базовые значения. Всё, что потом меняешь в настройках Noctalia
# (Mod+S → шестерёнка), сохраняется поверх них и имеет приоритет.
{ config, ... }:

let
  p = import ../theme/palette.nix;
  c = p.hex;
  home = config.home.homeDirectory;

  # Цвета терминала для шаблонов Noctalia
  terminal = {
    background = c.base00;
    foreground = c.base05;
    cursor = c.base08;
    selection_bg = c.base02;
    selection_fg = c.base07;
    # старые имена того же (для Noctalia < 5.4)
    cursorText = c.base00;
    selectionBg = c.base02;
    selectionFg = c.base07;
    cursor_text = c.base00;
    normal = {
      black = c.base00;
      red = c.base08;
      green = c.base0B;
      yellow = c.base0A;
      blue = c.base0D;
      magenta = c.base0E;
      cyan = c.base0C;
      white = c.base05;
    };
    bright = {
      black = c.base03;
      red = c.base08;
      green = c.base0B;
      yellow = c.base0A;
      blue = c.base0D;
      magenta = c.base0E;
      cyan = c.base0C;
      white = c.base07;
    };
  };

  # Палитра в формате Noctalia. Записаны оба варианта имён ролей:
  # новый (primary, surface…) и старый (mPrimary, mSurface…),
  # чтобы файл работал и до, и после обновления Noctalia.
  dark = {
    # красный — главный акцент: активный рабочий стол, переключатели
    primary = c.base08;
    on_primary = c.base07;
    # бронза — второй акцент
    secondary = c.base0F;
    on_secondary = c.base07;
    # холодный синий — третий
    tertiary = c.base0B;
    on_tertiary = c.base00;
    error = c.base08;
    on_error = c.base07;
    surface = c.base00;
    on_surface = c.base05;
    surface_container = c.base01;
    on_surface_variant = c.base04;
    outline_variant = c.base02;
    shadow = "#000000";
    hover = c.base02;
    on_hover = c.base07;

    mPrimary = c.base08;
    mOnPrimary = c.base07;
    mSecondary = c.base0F;
    mOnSecondary = c.base07;
    mTertiary = c.base0B;
    mOnTertiary = c.base00;
    mError = c.base08;
    mOnError = c.base07;
    mSurface = c.base00;
    mOnSurface = c.base05;
    mSurfaceVariant = c.base01;
    mOnSurfaceVariant = c.base04;
    mOutline = c.base02;
    mShadow = "#000000";
    mHover = c.base02;
    mOnHover = c.base07;

    inherit terminal;
  };
in
{
  xdg.configFile."noctalia/palettes/${p.name}.json".text = builtins.toJSON {
    version = 2;
    inherit dark;
  };

  xdg.configFile."noctalia/config.toml".text = ''
    # Базовые настройки Noctalia — генерирует Home Manager.
    # Правь /etc/nixos/home/noctalia.nix

    [shell]
    font_family         = "${p.font.mono}"
    corner_radius_scale = 0.35          # почти квадратные углы

    [shell.animation]
    enabled = true
    speed   = 1.5                       # быстрые, без лишней плавности

    [shell.panel]
    transparency_mode = "solid"
    borders           = true
    border_color      = "outline_variant"
    border_width      = 1.0
    shadow            = false

    [theme]
    mode           = "dark"
    source         = "custom"
    custom_palette = "${p.name}"

    [wallpaper]
    enabled    = true
    fill_mode  = "crop"
    fill_color = "surface"
    directory  = "${home}/Pictures/Wallpapers"

    [wallpaper.default]
    path = "${home}/Pictures/Wallpapers/machine/phase.png"

    [lockscreen]
    transition          = ["pixel"]     # пиксельное появление — ретро
    transition_duration = 900
    blur_intensity      = 0.0
    tint_intensity      = 0.55

    [bar.main]
    position           = "top"
    thickness          = 30
    background_opacity = 1.0
    compositor_blur    = false
    radius             = 0              # плоская панель во всю ширину
    margin_ends        = 0
    margin_edge        = 0
    shadow             = false
  '';
}
