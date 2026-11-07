# ─────────────────────────────────────────────────────────────────────
#  Разметка диска нового ноутбука (disko).
#  ВНИМАНИЕ: применение этого файла СТИРАЕТ весь диск `device`.
#  Используется только при установке на новый ноутбук (см. README.md).
#
#  Схема:  1 ГБ /boot (EFI)  +  всё остальное — btrfs с подтомами
#          @ → /   @home → /home   @nix → /nix   @swap → своп-файл
#  Сжатие zstd экономит место, noatime — лишние записи на SSD.
# ─────────────────────────────────────────────────────────────────────
let
  device = "/dev/nvme0n1"; # ✎ диск нового ноутбука: проверь через `lsblk`
  encrypt = false; # ✎ true — шифрование LUKS, пароль при каждом включении
  swapSize = "8G"; # своп на диске в дополнение к zram в памяти

  opts = [
    "compress=zstd"
    "noatime"
  ];

  btrfs = {
    type = "btrfs";
    extraArgs = [ "-f" ];
    subvolumes = {
      "@" = {
        mountpoint = "/";
        mountOptions = opts;
      };
      "@home" = {
        mountpoint = "/home";
        mountOptions = opts;
      };
      "@nix" = {
        mountpoint = "/nix";
        mountOptions = opts;
      };
      "@swap" = {
        mountpoint = "/.swapvol";
        swap.swapfile.size = swapSize;
      };
    };
  };
in
{
  disko.devices.disk.main = {
    type = "disk";
    inherit device;
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content =
            if encrypt then
              {
                type = "luks";
                name = "cryptroot";
                askPassword = true; # пароль спросят при разметке
                settings.allowDiscards = true; # TRIM для SSD
                content = btrfs;
              }
            else
              btrfs;
        };
      };
    };
  };
}
