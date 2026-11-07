# ─────────────────────────────────────────────────────────────────────
#  Шаблон нового ноутбука. Как поставить систему — см. README.md.
#  Перед установкой: скопируй папку в hosts/<имя> и поправь отмеченное ✎.
#  Папка с именем «template» в список систем не попадает.
# ─────────────────────────────────────────────────────────────────────
{ inputs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix # создаётся при установке (см. README.md)
    ./disko.nix # разметка диска: btrfs, по желанию шифрование
    inputs.disko.nixosModules.disko
    ../../modules
  ];

  networking.hostName = "template"; # ✎ то же имя, что у папки

  # ✎ Железо нового ноутбука
  machine = {
    igpu = "intel"; # или "amd"
    nvidia.enable = false; # true — если есть NVIDIA, тогда раскомментируй prime ниже
    display.scale = 1.0; # 1.25 = 125%
    # gpuLabel = "";  # пусто — fastfetch определит видеокарту сам
  };

  # Только при NVIDIA: адреса из `lspci` (формат PCI:шина:устройство:функция)
  # hardware.nvidia.prime = {
  #   intelBusId  = "PCI:0:2:0";
  #   nvidiaBusId = "PCI:1:0:0";
  # };

  # ── Снимки /home на btrfs ───────────────────────────────────────────
  # Каждый час снимок домашней папки; хранятся 5 часовых, 7 дневных,
  # 4 недельных. Вернуть файл: `snapper -c home list`, затем
  # `snapper -c home undochange <номер>..0 <путь>`
  services.snapper.configs.home = {
    SUBVOLUME = "/home";
    ALLOW_USERS = [ username ];
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    TIMELINE_LIMIT_HOURLY = 5;
    TIMELINE_LIMIT_DAILY = 7;
    TIMELINE_LIMIT_WEEKLY = 4;
    TIMELINE_LIMIT_MONTHLY = 0;
    TIMELINE_LIMIT_YEARLY = 0;
  };

  # ✎ Версия NixOS на момент установки. После установки не меняй.
  system.stateVersion = "26.11";
}
