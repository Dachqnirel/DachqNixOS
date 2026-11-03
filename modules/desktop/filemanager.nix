# Dolphin везде: файловый менеджер и диалоги «Открыть/Сохранить».
# Цвета и иконки для него — в theme.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.kdePackages; [
    dolphin
    kio-extras # превью картинок, телефоны по MTP, архивы
    kdegraphics-thumbnailers # превью PDF
    ffmpegthumbs # превью видео
  ];

  # Раздел «Devices» в Dolphin: корневой диск, флешки, другие разделы
  services.udisks2.enable = true;

  # Диалоги «Открыть/Сохранить» во всех программах — как в Dolphin
  xdg.portal = {
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.niri."org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
  };

  # Папки по умолчанию открываются в Dolphin
  xdg.mime.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
}
