# niri + Noctalia — рабочий стол вместо Plasma
{ lib, pkgs, ... }:

{
  # ── Композитор и экран входа ────────────────────────────────────────
  programs.niri.enable = true;
  services.xserver.enable = true;              # нужен экрану входа SDDM
  services.displayManager.sddm.enable = true;

  # ── Noctalia: панель, меню, уведомления, центр управления ──────────
  # Стартует вместе с сессией niri как служба пользователя.
  # Старая версия называется pkgs.noctalia-shell — если что, меняем тут.
  systemd.user.services.noctalia = {
    description = "Noctalia shell";
    wantedBy = [ "graphical-session.target" ];
    partOf   = [ "graphical-session.target" ];
    after    = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.noctalia;
      Restart   = "on-failure";
    };
  };

  # Раньше их включала Plasma; Noctalia берёт из них батарею и режимы питания
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # ── То, что раньше давала Plasma ────────────────────────────────────
  # Окно ввода пароля для программ, которым нужны права (virt-manager и т.п.)
  systemd.user.services.polkit-agent = {
    description = "polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    partOf   = [ "graphical-session.target" ];
    after    = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart   = "on-failure";
    };
  };

  # Хранилище паролей вместо KWallet (VS Code, Telegram и др.)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Окна «Открыть/Сохранить файл»
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.systemPackages = with pkgs; [
    noctalia
    fuzzel                 # запуск программ (Super+D)
    swaylock               # запасной экран блокировки
    xwayland-satellite     # X11-программы (Firefox, VS Code, Telegram)
    pavucontrol            # подробные настройки звука
    kdePackages.dolphin    # файловый менеджер
    kdePackages.kate       # текстовый редактор
    kdePackages.ark        # архивы
  ];
}
