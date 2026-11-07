# ─────────────────────────────────────────────────────────────────────
#  Игровой пользователь: Steam, Minecraft (microlauncher) и всё игровое
#  живут в его домашней папке и не мешают рабочему профилю.
#
#  На экране входа (F3 — выбор сеанса) у него два режима:
#    Steam — консоль: Big Picture на весь экран через gamescope
#    niri  — обычный рабочий стол с той же темой, Steam в окне
#  tuigreet запоминает выбор для каждого пользователя.
# ─────────────────────────────────────────────────────────────────────
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.gaming;
  microlauncher = inputs.microlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.gaming = {
    enable = lib.mkEnableOption "игрового пользователя со Steam";
    user = lib.mkOption {
      type = lib.types.str;
      default = "play";
      description = "Имя игрового пользователя.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isNormalUser = true;
      description = "Игры";
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "video"
        "audio"
        "input" # геймпады
        "gamemode"
      ];
      # Программы только этого пользователя: в рабочем профиле их нет
      packages = with pkgs; [
        microlauncher
        mangohud # оверлей: FPS, температуры, загрузка (MANGOHUD=1 %command%)
        protonup-qt # ещё версии Proton, если понадобятся
      ];
    };

    # Steam ставится на всю систему (так устроен модуль), но в рабочем
    # профиле его ярлык скрыт — см. home/work.nix
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true; # сеанс «Steam» на экране входа
      extraCompatPackages = [ pkgs.proton-ge-bin ]; # Proton-GE: больше игр без плясок
      protontricks.enable = true;
    };

    # Режим производительности на время игры: gamemoderun %command%
    programs.gamemode.enable = true;

    # Home Manager: та же тема и программы, что у рабочего профиля,
    # плюс игровые мелочи
    home-manager.users.${cfg.user}.imports = [
      ../../home
      ../../home/gaming.nix
    ];
  };
}
