# DachqNixOS

NixOS-конфигурация dachQnirel: niri + Noctalia, тема «машинный минимализм»
(Base16 Default Dark + красный акцент), Home Manager, neovim-IDE.

## Устройство

```
flake.nix            список систем: каждая папка в hosts/ — отдельный ноутбук
hosts/
  ideapad/           Lenovo IdeaPad Gaming 3 (i7-12700H + RTX 3060)
  template/          шаблон для нового ноутбука (+ disko.nix — разметка диска)
modules/             общее для всех: система, графика, рабочий стол, программы
  machine.nix        опции machine.* — чем ноутбуки отличаются друг от друга
  gaming/            игровой пользователь play: Steam, Minecraft
home/                Home Manager: niri, Noctalia, foot, fastfetch, neovim, GTK
  work.nix           только рабочий профиль (игр не видно)
  gaming.nix         только игровой: MangoHud, режим «Производительность»
theme/palette.nix    единая палитра — меняешь цвет здесь, он меняется везде
```

Отличия конкретного ноутбука задаются в `hosts/<имя>/default.nix`:

```nix
machine = {
  igpu = "intel";            # или "amd"
  nvidia.enable = true;      # гибридная графика NVIDIA
  display.scale = 1.25;      # масштаб экрана
};
```

## Два профиля: работа и игры

- `dachqnirel` — работа: niri, Noctalia, neovim. Steam здесь скрыт.
- `play` — игры: Steam, microlauncher (Minecraft), MangoHud, gamemode.
  Тема и программы те же, но домашняя папка своя.

Вход как `play` — обычный niri, Steam в окне; игры идут на дискретной
видеокарте. Big Picture на весь экран — кнопка в самом Steam.

В играх: `Shift_R+F12` — оверлей (FPS, видеокарта, температуры),
`Shift_L+F1` — лимит кадров 120 → 60 → без лимита (по умолчанию 120:
меньше нагрев и шум). Пока вошёл `play`, включён профиль питания
«Производительность» — вентиляторы раскручиваются раньше.
Для тяжёлых игр в свойствах (Launch Options): `gamemoderun %command%`.

Включается одной строкой в `hosts/<имя>/default.nix`: `gaming.enable = true;`

## Claude Code и прокси

Через прокси ходит только то, что запущено через него:

```bash
proxy-set http://логин:пароль@хост:порт   # или socks5://… — один раз
claude                                    # Claude Code, всегда через прокси
px git push                               # любая команда через прокси
proxy-set -                               # убрать прокси
```

Адрес хранится в `~/.config/proxy/url` (права 600), в репозиторий не попадает.

## Каждый день

```bash
sudo nixos-rebuild switch --flake /etc/nixos          # применить изменения
sudo nix flake update --flake /etc/nixos              # обновить все пакеты
sudo nix flake update microlauncher --flake /etc/nixos  # только лаунчер
```

Система выбирается автоматически по имени компьютера (`hostName`).

## Установка на новый ноутбук

1. Загрузиться с флешки NixOS (minimal ISO), подключить интернет:
   `nmtui` для Wi-Fi.
2. Скачать конфиг:
   ```bash
   nix-shell -p git
   git clone https://github.com/Dachqnirel/DachqNixOS /tmp/cfg
   cd /tmp/cfg
   ```
3. Завести папку нового ноутбука из шаблона (имя — любое, латиницей):
   ```bash
   cp -r hosts/template hosts/thinkpad
   ```
   В `hosts/thinkpad/default.nix` поправить строки с ✎: `hostName`,
   `machine.*`, `stateVersion`. В `hosts/thinkpad/disko.nix` — `device`
   (проверить через `lsblk`) и `encrypt`.
4. Разметить диск. **Это сотрёт весь диск `device`!**
   ```bash
   sudo nix --experimental-features "nix-command flakes" \
     run github:nix-community/disko/latest -- \
     --mode destroy,format,mount hosts/thinkpad/disko.nix
   ```
5. Описание железа (без разделов — их описывает disko):
   ```bash
   sudo nixos-generate-config --no-filesystems --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix hosts/thinkpad/
   ```
6. Установить:
   ```bash
   git add -A
   sudo mkdir -p /mnt/etc && sudo cp -r /tmp/cfg /mnt/etc/nixos
   sudo nixos-install --flake /mnt/etc/nixos#thinkpad
   ```
   В конце установщик спросит пароль root.
7. Задать пароль пользователю и перезагрузиться:
   ```bash
   sudo nixos-enter --root /mnt -c 'passwd dachqnirel'
   reboot
   ```
8. После входа — закоммитить новый хост и отправить на GitHub:
   ```bash
   cd /etc/nixos && sudo git add -A && sudo git commit -m "хост thinkpad" && sudo git push
   ```

## Откат

Если новая версия не загружается — в меню загрузки выбрать предыдущую.
Из рабочей системы: `sudo nixos-rebuild switch --rollback`.
