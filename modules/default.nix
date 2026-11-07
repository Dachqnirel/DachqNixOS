# Всё общее — одинаково на любом ноутбуке.
# Отличия конкретной машины задаются в hosts/<имя>/default.nix
# через опции machine.* (см. ./machine.nix).
{
  imports = [
    ./machine.nix # описание железа: NVIDIA, экран, встроенная графика
    ./system # загрузчик, nix, локаль, сеть, пользователь
    ./hardware # графика, NVIDIA (если есть), звук, bluetooth
    ./desktop # niri, Noctalia, тема, Home Manager
    ./services # Docker, KVM, прокси, печать
    ./packages # программы
  ];
}
