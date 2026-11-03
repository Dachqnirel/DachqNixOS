# Home Manager: всё, что живёт в домашней папке.
# Правишь файлы здесь → sudo nixos-rebuild switch --flake /etc/nixos
{ username, ... }:

{
  imports = [
    ./niri.nix # бинды, окна, цвета niri
    ./noctalia.nix # панель, палитра, экран блокировки
    ./terminal.nix # foot и fastfetch
    ./neovim.nix # редактор-IDE
    ./desktop.nix # GTK, курсор, обои
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Версия, с которой начали пользоваться Home Manager. Не меняй при обновлениях.
  home.stateVersion = "26.05";
}
