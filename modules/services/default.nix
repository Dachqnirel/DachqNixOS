# Фоновые службы
{
  imports = [
    ./podman.nix # контейнеры (вместо Docker)
    ./virtualisation.nix
    ./proxy.nix
    ./printing.nix
  ];
}
