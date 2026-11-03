# Машинный минимализм: шрифты, цвета для Qt/KDE (Dolphin, Kate, Ark),
# тёмный режим для GTK, иконки, консоль и чистая загрузка.
# Палитра — в ../../theme/palette.nix
{ lib, pkgs, ... }:

let
  p = import ../../theme/palette.nix;
  c = p.rgb;

  # Одна группа схемы цветов KDE: фон + общий набор цветов текста
  kdeGroup = name: bg: bgAlt: ''
    [Colors:${name}]
    BackgroundNormal=${bg}
    BackgroundAlternate=${bgAlt}
    ForegroundNormal=${c.base05}
    ForegroundInactive=${c.base03}
    ForegroundActive=${c.base08}
    ForegroundLink=${c.base0D}
    ForegroundVisited=${c.base0E}
    ForegroundNegative=${c.base08}
    ForegroundNeutral=${c.base09}
    ForegroundPositive=${c.base0B}
    DecorationFocus=${c.base08}
    DecorationHover=${c.base03}

  '';

  kdeColors = ''
    [ColorEffects:Disabled]
    Color=${c.base02}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${c.base03}
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

  ''
  + kdeGroup "Window" c.base00 c.mid
  + kdeGroup "View" c.base00 c.mid
  + kdeGroup "Button" c.base01 c.base02
  + kdeGroup "Header" c.mid c.base00
  + kdeGroup "Tooltip" c.base01 c.base00
  + kdeGroup "Complementary" c.deep c.base00
  + ''
    [Colors:Selection]
    BackgroundNormal=${c.base08}
    BackgroundAlternate=${c.base02}
    ForegroundNormal=${c.base07}
    ForegroundInactive=${c.base06}
    ForegroundActive=${c.base07}
    ForegroundLink=${c.base07}
    ForegroundVisited=${c.base06}
    ForegroundNegative=${c.base07}
    ForegroundNeutral=${c.base0A}
    ForegroundPositive=${c.base0B}
    DecorationFocus=${c.base08}
    DecorationHover=${c.base03}

    [WM]
    activeBackground=${c.mid}
    activeForeground=${c.base05}
    inactiveBackground=${c.base00}
    inactiveForeground=${c.base03}
    activeBlend=${c.base05}
    inactiveBlend=${c.base03}

  '';

  # Файл схемы — чтобы она была в списке «Window Color Scheme» у Dolphin/Kate
  kdeScheme = pkgs.writeTextDir "share/color-schemes/${p.name}.colors" (
    kdeColors
    + ''
      [General]
      ColorScheme=${p.name}
      Name=${p.name}
    ''
  );

  # Общие настройки KDE-программ. Пользовательский ~/.config/kdeglobals
  # дописывается поверх этого файла, поэтому ничего не ломает.
  kdeglobals = pkgs.writeText "kdeglobals" (
    kdeColors
    + ''
      [General]
      ColorScheme=${p.name}
      font=${p.font.sans},${toString p.font.size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1
      fixed=${p.font.mono},${toString p.font.size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1

      [UiSettings]
      ColorScheme=${p.name}

      [Icons]
      Theme=Papirus-Dark

      [KDE]
      widgetStyle=Breeze
    ''
  );

  # Иконки Papirus с серыми папками
  papirusGrey = pkgs.papirus-icon-theme.override { color = "grey"; };
in
{
  # ── Шрифты: IBM Plex везде, Terminus для консоли ────────────────────
  fonts.packages = with pkgs; [
    ibm-plex
    nerd-fonts.blex-mono
    terminus_font
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = lib.mkBefore [ p.font.sans ];
    serif = lib.mkBefore [ p.font.serif ];
    monospace = lib.mkBefore [ p.font.mono ];
  };

  # ── Qt / KDE: Dolphin, Kate, Ark, диалоги «Открыть/Сохранить» ───────
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };
  environment.etc."xdg/kdeglobals".source = kdeglobals;
  environment.pathsToLink = [ "/share/color-schemes" ];
  environment.systemPackages = [
    kdeScheme
    papirusGrey
    pkgs.bibata-cursors
  ];

  # ── Общий тёмный режим: его видят GTK-программы, Firefox и Qt ───────
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        accent-color = "slate";
      };
    }
  ];

  # ── Консоль и экран входа: Terminus + та же палитра ─────────────────
  console = {
    earlySetup = lib.mkDefault true;
    font = lib.mkDefault "ter-v24n";
    packages = [ pkgs.terminus_font ];
    colors = p.ansi;
  };

  # ── Чистая загрузка: без простыни сообщений перед экраном входа ─────
  boot.kernelParams = [
    "quiet"
    "udev.log_level=3"
  ];
  boot.consoleLogLevel = lib.mkDefault 3;
  boot.initrd.verbose = lib.mkDefault false;

  # Ранний KMS: драйвер Intel грузится сразу, и экран входа
  # появляется в полном разрешении, а не в углу
  boot.initrd.kernelModules = [ "i915" ];
}
