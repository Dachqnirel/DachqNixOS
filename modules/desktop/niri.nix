# niri — тайловый Wayland-композитор.
# Пока стоит рядом с Plasma: сессия выбирается на экране входа.
{ lib, pkgs, ... }:

{
  programs.niri.enable = true;

  # И Plasma, и niri хотят быть сессией по умолчанию — решаем явно.
  # SDDM всё равно запоминает последнюю выбранную сессию.
  services.displayManager.defaultSession = lib.mkForce "plasma";

  environment.systemPackages = with pkgs; [
    fuzzel               # запуск программ (Super+D)
    waybar               # панель сверху
    mako                 # уведомления
    swaylock             # блокировка экрана
    swaybg               # обои
    xwayland-satellite   # запуск X11-программ (Firefox, VS Code, Telegram)
  ];
}
