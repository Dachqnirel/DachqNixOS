# ─────────────────────────────────────────────────────────────────────
#  Хост «ideapad» — Lenovo IdeaPad Gaming 3 16IAH7
#  (i7-12700H + RTX 3060, экран 1920x1200@165).
#  Здесь только то, что относится к ЭТОМУ железу и ЭТОЙ установке.
#  Всё общее живёт в ../../modules и ../../home.
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  imports = [
    ./hardware-configuration.nix # сгенерирован nixos-generate-config, руками не трогаем
    ../../modules
  ];

  networking.hostName = "ideapad";

  # ── Железо этого ноутбука ───────────────────────────────────────────
  machine = {
    igpu = "intel";
    nvidia.enable = true;
    display = {
      output = "eDP-1";
      scale = 1.25; # 125%, как было в Plasma
    };
    gpuLabel = "RTX 3060 Mobile + Iris Xe";
  };

  # Адреса видеокарт именно этого ноутбука (из `lspci`)
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Игровой пользователь play: Steam, Minecraft (см. modules/gaming)
  gaming.enable = true;

  # Отключаем автосон USB (специфично для этого ноутбука)
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Версия NixOS, с которой система была УСТАНОВЛЕНА.
  # Не меняй при обновлениях — это не «текущая версия».
  system.stateVersion = "26.05";
}
