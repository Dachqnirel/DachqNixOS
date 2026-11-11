# ─────────────────────────────────────────────────────────────────────
#  Контейнеры: Podman вместо Docker.
#  Без постоянно работающего демона (ничего не висит в фоне и не ест
#  батарею), контейнеры по умолчанию от твоего пользователя, без root.
#
#    podman run …            — как docker run
#    docker run …            — то же самое (совместимая команда)
#    podman compose up -d    — docker-compose.yml работают как есть
#    podman-tui              — контейнеры и образы в терминальном интерфейсе
# ─────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # команда `docker` → podman, старые скрипты работают
    # Контейнеры из одного compose находят друг друга по имени
    defaultNetwork.settings.dns_enabled = true;
    # Раз в неделю удалять неиспользуемые образы и остановленные контейнеры
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose # `podman compose` для docker-compose.yml
    podman-tui
  ];
}
