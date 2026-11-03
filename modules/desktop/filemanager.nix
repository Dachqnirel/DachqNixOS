# Dolphin везде: файловый менеджер, диалоги «Открыть/Сохранить», тёмная тема Breeze
{ pkgs, ... }:

let
  # Цвета Breeze Dark и тёмные иконки для всех Qt/KDE-программ
  kdeglobals = pkgs.runCommand "kdeglobals" { } ''
    cat ${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors > $out
    printf '\n[Icons]\nTheme=breeze-dark\n' >> $out
  '';
in
{
  environment.systemPackages = with pkgs.kdePackages; [
    dolphin
    breeze-icons
    kio-extras                 # превью картинок, телефоны по MTP, архивы
    kdegraphics-thumbnailers   # превью PDF
    ffmpegthumbs               # превью видео
  ];

  # Qt-программы получают стиль, цвета и иконки как в Plasma
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };
  environment.etc."xdg/kdeglobals".source = kdeglobals;

  # Раздел «Devices» в Dolphin: корневой диск, флешки, другие разделы
  services.udisks2.enable = true;

  # Диалоги «Открыть/Сохранить» во всех программах — как в Dolphin
  xdg.portal = {
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.niri."org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
  };

  # Папки по умолчанию открываются в Dolphin
  xdg.mime.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";

  # Схемы цветов (Breeze Dark и др.) видны всем программам
  environment.pathsToLink = [ "/share/color-schemes" ];

  # Общий тёмный режим системы: его подхватывают Dolphin, GTK-программы и Firefox
  programs.dconf.profiles.user.databases = [
    { settings."org/gnome/desktop/interface".color-scheme = "prefer-dark"; }
  ];
}
