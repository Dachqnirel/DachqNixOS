# Графические приложения
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Браузеры (Firefox настроен в desktop/firefox.nix)
    brave

    # Общение
    telegram-desktop
    ayugram-desktop

    # Заметки, наука, офис
    obsidian
    zotero
    libreoffice-stable

    # Терминалы
    alacritty
    kitty
  ];
}
