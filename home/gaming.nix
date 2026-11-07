# Только для игрового пользователя (см. modules/gaming)
{ lib, osConfig, ... }:

let
  nvidia = osConfig.machine.nvidia.enable;
in
{
  # В режиме niri Steam и всё, что он запускает, работает на дискретной
  # видеокарте. Ярлык подменяется: в лаунчере тот же «Steam».
  xdg.desktopEntries.steam = lib.mkIf nvidia {
    name = "Steam";
    genericName = "Игры";
    icon = "steam";
    exec = "nvidia-offload steam %U";
    terminal = false;
    categories = [ "Game" ];
    mimeType = [
      "x-scheme-handler/steam"
      "x-scheme-handler/steamlink"
    ];
  };
}
