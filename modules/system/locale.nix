# Время, язык, раскладка
{
  time.timeZone = "Europe/Moscow";

  # Интерфейс на английском, форматы (даты, числа, валюта) — русские
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT    = "ru_RU.UTF-8";
    LC_MONETARY       = "ru_RU.UTF-8";
    LC_NAME           = "ru_RU.UTF-8";
    LC_NUMERIC        = "ru_RU.UTF-8";
    LC_PAPER          = "ru_RU.UTF-8";
    LC_TELEPHONE      = "ru_RU.UTF-8";
    LC_TIME           = "ru_RU.UTF-8";
  };

  # us/ru, переключение на Caps Lock
  services.xserver.xkb = {
    layout  = "us,ru";
    variant = "";
    options = "grp:caps_toggle";
  };
}
