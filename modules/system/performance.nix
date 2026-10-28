# Оптимизации: быстрее загрузка, меньше лагов, нет зависаний от нехватки памяти
{ pkgs, ... }:

{
  # Сжатый своп в оперативке: при нехватке памяти система не «встаёт колом»
  zramSwap.enable = true;

  # Если память всё же кончается — убить самый жадный процесс, а не зависнуть
  services.earlyoom.enable = true;

  # Не ждать подключения к сети при загрузке (экономит несколько секунд)
  systemd.services.NetworkManager-wait-online.enable = false;

  # Docker запускается при первом обращении, а не при каждой загрузке
  virtualisation.docker.enableOnBoot = false;

  # Discover на NixOS бесполезен (программы ставятся через конфиг),
  # а его уведомлялка висит в фоне и проверяет обновления
  environment.plasma6.excludePackages = [ pkgs.kdePackages.discover ];

  # Раз в неделю TRIM для SSD — диск не замедляется со временем
  services.fstrim.enable = true;
}
