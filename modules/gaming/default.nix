# ─────────────────────────────────────────────────────────────────────
#  Игровой пользователь: Steam, Minecraft (microlauncher) и всё игровое
#  живут в его домашней папке и не мешают рабочему профилю.
#
#  Сеанс — niri с той же темой; Steam при входе сразу в Big Picture
#  (интерфейс SteamOS, см. home/niri.nix).
#  (Консольный сеанс gamescope убран: на ноутбуке с двумя видеокартами
#  он работал заметно хуже, чем Steam внутри niri.)
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
  # Переменные действуют только внутри Steam: niri остаётся
  # на встроенной, дискретка работает, только пока открыт Steam.
  primeOffload = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";

    # DLSS и Reflex в Windows-играх через Proton
    PROTON_ENABLE_NVAPI = "1";

    # Кэш шейдеров побольше (по умолчанию ~1 ГБ на всё): меньше
    # подтормаживаний, когда игра впервые видит новый эффект или уровень
    __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
  };

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
    pauseUntil = lib.mkOption {
      type = lib.types.nullOr (lib.types.strMatching "[0-9]{4}-[0-9]{2}-[0-9]{2}");
      default = null;
      example = "2026-11-28";
      description = ''
        Перерыв от игр: до этой даты (ГГГГ-ММ-ДД) вход в игровой профиль
        закрыт. В этот день он откроется сам, пересобирать не нужно.
        null — перерыва нет.
      '';
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
        pkgs.mangohud # чтобы MangoHud был виден играм внутри Steam
      ];
      extraCompatPackages = [ pkgs.proton-ge-bin ]; # Proton-GE: больше игр без плясок
      protontricks.enable = true;
    };

    # Режим производительности на время игры: gamemoderun %command%
    # (частоты и профиль питания уже подняты на весь сеанс play —
    # см. home/gaming.nix; gamemode добавляет приоритет самой игре)
    programs.gamemode.enable = true;

    # ── Перерыв от игр ─────────────────────────────────────────────────
    # При загрузке и каждый час сверяет дату: до gaming.pauseUntil
    # игровой профиль заблокирован (вход отклоняется), после — открыт.
    systemd.services.gaming-pause = {
      description = "Перерыв от игр: блокировка профиля ${cfg.user}";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig.Type = "oneshot";
      path = [ pkgs.shadow pkgs.coreutils ];
      script =
        if cfg.pauseUntil == null then
          ''
            usermod -U -e "" ${cfg.user} 2>/dev/null || true
          ''
        else
          ''
            if [ "$(date +%F)" \< "${cfg.pauseUntil}" ]; then
              usermod -L -e 1 ${cfg.user}
              echo "Перерыв от игр: ${cfg.user} закрыт до ${cfg.pauseUntil}"
            else
              usermod -U -e "" ${cfg.user} 2>/dev/null || true
              echo "Перерыв закончился: ${cfg.user} открыт"
            fi
          '';
    };
    systemd.timers.gaming-pause = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
    };

    # Как в SteamOS: ядро не тормозит программы за «split lock».
    # Некоторые Windows-игры из-за этого заметно дёргаются.
    boot.kernel.sysctl."kernel.split_lock_mitigate" = 0;

    # Home Manager: та же тема и программы, что у рабочего профиля,
    # плюс игровые мелочи
    home-manager.users.${cfg.user}.imports = [
      ../../home
      ../../home/gaming.nix # MangoHud, режим «Производительность»
    ];
  };
}
