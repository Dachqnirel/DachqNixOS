# ─────────────────────────────────────────────────────────────────────
#  Хост «nixos» — конкретный ноутбук.
#  Здесь только то, что относится к ЭТОМУ железу и ЭТОЙ установке.
#  Всё переиспользуемое живёт в ./modules.
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  imports = [
    ./hardware-configuration.nix   # сгенерирован nixos-generate-config, руками не трогаем

    ./modules/system           # загрузчик, nix, локаль, сеть, пользователь
    ./modules/hardware         # NVIDIA, звук, bluetooth
    ./modules/desktop          # Plasma, шрифты, Firefox
    ./modules/services         # Docker, KVM, прокси, печать
    ./modules/packages         # программы
  ];

  networking.hostName = "nixos";

  # Отключаем автосон USB (специфично для этого ноутбука)
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Адреса видеокарт именно этого ноутбука (из `lspci`)
  hardware.nvidia.prime = {
    intelBusId  = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Версия NixOS, с которой система была УСТАНОВЛЕНА.
  # Не меняй при обновлениях — это не «текущая версия».
  system.stateVersion = "26.05";
}
