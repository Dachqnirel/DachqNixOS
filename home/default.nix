# Home Manager: всё, что живёт в домашней папке.
# Правишь файлы здесь → sudo nixos-rebuild switch --flake /etc/nixos
# Общее для всех пользователей; имя и домашнюю папку подставляет
# Home Manager (см. modules/desktop/home.nix и modules/gaming).

{
  imports = [
    ./niri.nix # бинды, окна, цвета niri
    ./noctalia.nix # панель, палитра, экран блокировки
    ./terminal.nix # foot и fastfetch
    ./neovim.nix # редактор-IDE
    ./desktop.nix # GTK, курсор, обои
  ];

  # Версия, с которой начали пользоваться Home Manager. Не меняй при обновлениях.
  home.stateVersion = "26.05";
}
