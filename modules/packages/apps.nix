# Графические приложения
{ pkgs, ... }:

{
  programs.java = { enable = true; package = pkgs.jdk25; };

  environment.systemPackages = with pkgs; [
    # Браузеры (Firefox настроен в desktop/firefox.nix)

    # Общение
    _64gram # форк Telegram: можно отключить глобальный поиск
    ayugram-desktop

    # Заметки, наука, офис
    obsidian
    zotero
    libreoffice-qt-stable
    # microlauncher — у игрового пользователя, см. modules/gaming
  ];
}
