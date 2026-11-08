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
  nvidia = config.machine.nvidia.enable;

  # Steam и всё, что он запускает, рисуют на дискретной видеокарте.
  # Переменные действуют только внутри Steam: niri и gamescope остаются
  # на встроенной, дискретка работает, только пока открыт Steam.
  primeOffload = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
  };

  # Big Picture → «Переключиться на рабочий стол» вызывает эту команду
  # (на SteamOS она меняет сеанс). Здесь — просто закрыть Steam: сеанс
  # gamescope завершится и вернётся экран входа.
  sessionSelect = pkgs.writeShellScriptBin "steamos-session-select" ''
    exec steam -shutdown
  '';
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
        nvtopPackages.full # загрузка и температура обеих видеокарт
        lm_sensors # `sensors` — температуры процессора и вентиляторы
        protonup-qt # ещё версии Proton, если понадобятся
      ];
    };

    # Steam ставится на всю систему (так устроен модуль), но в рабочем
    # профиле его ярлык скрыт — см. home/work.nix
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = "1"; # оверлей и лимит кадров во всех играх (см. home/gaming.nix)
        }
        // lib.optionalAttrs nvidia primeOffload;
      };
      extraPackages = [
        sessionSelect
        pkgs.mangohud # чтобы MangoHud был виден играм внутри Steam
      ];
      gamescopeSession = {
        enable = true; # сеанс «Steam» на экране входа
        steamArgs = [
          "-tenfoot" # сразу Big Picture
          "-pipewire-dmabuf"
          "-steamos3" # меню питания как на SteamOS: «Переключиться на рабочий стол»
        ];
      };
      extraCompatPackages = [ pkgs.proton-ge-bin ]; # Proton-GE: больше игр без плясок
      protontricks.enable = true;
    };

    # Режим производительности на время игры: gamemoderun %command%
    programs.gamemode.enable = true;

    # Home Manager: та же тема и программы, что у рабочего профиля,
    # плюс игровые мелочи
    home-manager.users.${cfg.user}.imports = [
      ../../home
      ../../home/gaming.nix # MangoHud, режим «Производительность»
    ];
  };
}
