# Графические приложения
{ pkgs, inputs, ... }:

{
  programs.java = { enable = true; package = pkgs.jdk25; };

  environment.systemPackages = with pkgs; [
    # Браузеры (Firefox настроен в desktop/firefox.nix)
    brave

    # Общение
    telegram-desktop
    ayugram-desktop

    # Заметки, наука, офис
    obsidian
    zotero
    libreoffice-qt-stable
    inputs.microlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
