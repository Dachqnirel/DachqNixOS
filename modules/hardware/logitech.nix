# Устройства Logitech через приёмник Unifying/Bolt:
# Solaar в трее — заряд, DPI, кнопки, сопряжение (замена Logi Options+)
{ pkgs, ... }:

{
  # Правила udev: доступ к приёмнику без sudo
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Запуск вместе с niri, сразу свёрнутым в трей
  systemd.user.services.solaar = {
    description = "Solaar: устройства Logitech";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.solaar}/bin/solaar --window=hide";
      Restart = "on-failure";
    };
  };
}
