# niri + Noctalia — рабочий стол вместо Plasma.
# Конфиг самого niri (бинды, окна, цвета) — в ../../home/niri.nix
{ config, lib, pkgs, ... }:

let
  # Экран входа: текстовый, в палитре системы (цвета консоли = палитра)
  tuigreetTheme = lib.concatStringsSep ";" [
    "border=darkgray"
    "title=red"
    "text=gray"
    "greet=red"
    "prompt=red"
    "input=white"
    "time=darkgray"
    "action=darkgray"
    "button=red"
    "container=black"
  ];
in
{
  # ── Композитор ──────────────────────────────────────────────────────
  programs.niri.enable = true;

  # ── Экран входа: greetd + tuigreet вместо SDDM ──────────────────────
  # Работает без X-сервера: меньше процессов, дискретку никто не держит.
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = lib.concatStringsSep " " [
      "${pkgs.tuigreet}/bin/tuigreet"
      "--time"
      "--remember"
      "--asterisks"
      "--width 60"
      "--greeting '+++ MACHINE SPIRIT AWAITS +++'"
      "--theme '${tuigreetTheme}'"
      "--cmd ${config.programs.niri.package}/bin/niri-session"
    ];
  };

  # ── Noctalia: панель, меню, уведомления, экран блокировки ──────────
  # Стартует вместе с сессией niri как служба пользователя.
  systemd.user.services.noctalia = {
    enableDefaultPath = false; # PATH из сессии niri, иначе лаунчер не видит программы
    description = "Noctalia shell";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.noctalia;
      Restart = "on-failure";
    };
  };

  # Батарея и режимы питания для Noctalia
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # ── То, что раньше давала Plasma ────────────────────────────────────
  # Окно ввода пароля для программ, которым нужны права (virt-manager и т.п.)
  systemd.user.services.polkit-agent = {
    description = "polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  # Хранилище паролей (VS Code, Telegram и др.) — открывается паролем входа
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Окна «Открыть/Сохранить» для GTK (основные — от Dolphin, см. filemanager.nix)
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.systemPackages = with pkgs; [
    noctalia
    xwayland-satellite # X11-программы
    pavucontrol # подробные настройки звука
    playerctl # кнопки медиа на клавиатуре
    kdePackages.kate # текстовый редактор
    kdePackages.ark # архивы
  ];
}
