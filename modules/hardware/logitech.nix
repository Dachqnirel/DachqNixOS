# Устройства Logitech через приёмник Unifying/Bolt:
# Solaar в трее — заряд, DPI, кнопки, сопряжение (замена Logi Options+)
{
  programs.solaar = {
    enable = true; # сам Solaar + правила udev (доступ без sudo)
    userService = {
      enable = false; # не запускать постоянно: заряд и так показывает ядро
      window = "hide"; # сразу свёрнут в трей
      batteryIcons = "symbolic"; # строгие иконки заряда, под тему
    };
  };
}
