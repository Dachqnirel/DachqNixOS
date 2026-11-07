# Конфиг niri. Файл ~/.config/niri/config.kdl собирается отсюда и
# проверяется (`niri validate`) ещё при сборке: с ошибкой система просто
# не соберётся, а рабочий конфиг останется прежним.
{
  config,
  pkgs,
  osConfig,
  ...
}:

let
  p = import ../theme/palette.nix;
  c = p.hex;
  display = osConfig.machine.display; # экран задаётся в hosts/<имя>/default.nix

  niriConfig = ''
    // ─────────────────────────────────────────────────────────────────
    //  niri — машинный минимализм.
    //  Файл генерирует Home Manager: правь /etc/nixos/home/niri.nix
    // ─────────────────────────────────────────────────────────────────

    input {
        disable-power-key-handling // кнопка питания выключает, а не усыпляет

        keyboard {
            xkb {
                layout "us,ru"
                options "grp:caps_toggle"
            }
            numlock
        }

        touchpad {
            tap
            natural-scroll
        }
    }

    // Встроенный экран: имя и масштаб — из hosts/<имя>/default.nix
    output "${display.output}" {
        scale ${toString display.scale}
    }

    layout {
        gaps 10
        center-focused-column "never"
        background-color "${c.base00}"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }

        // Вместо светящегося кольца — тонкая рамка: красная у активного окна
        focus-ring {
            off
        }
        border {
            on
            width 2
            active-color "${c.base08}"
            inactive-color "${c.base02}"
            urgent-color "${c.base09}"
        }

        shadow {
            off
        }
    }

    overview {
        backdrop-color "${c.deep}"
        workspace-shadow {
            off
        }
    }

    cursor {
        xcursor-theme "Bibata-Modern-Classic"
        xcursor-size 24
        hide-when-typing
    }

    prefer-no-csd

    hotkey-overlay {
        skip-at-startup
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // Тема Qt для программ, запущенных из niri (Dolphin, Kate, Telegram)
    environment {
        QT_QPA_PLATFORMTHEME "kde"
        QT_STYLE_OVERRIDE "breeze"
    }

    // Анимации чуть быстрее стандартных
    animations {
        slowdown 0.8
    }

    // ── Окна ──────────────────────────────────────────────────────────
    window-rule {
        geometry-corner-radius ${toString p.radius}
        clip-to-geometry true
    }

    // Терминал: лёгкое размытие обоев под полупрозрачным фоном
    window-rule {
        match app-id="^foot(client)?$"
        background-effect {
            blur true
        }
        draw-border-with-background false
    }

    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }

    // Настройки Noctalia — плавающим окном
    window-rule {
        match app-id=r#"^dev\.noctalia\.Noctalia\.Settings$"#
        open-floating true
        default-column-width { fixed 1080; }
        default-window-height { fixed 920; }
    }

    // Клик по уведомлению Noctalia открывает нужное окно
    debug {
        honor-xdg-activation-with-invalid-serial
    }

    // ── Клавиши ───────────────────────────────────────────────────────
    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        // Программы
        Mod+T hotkey-overlay-title="Терминал" { spawn-sh "footclient --no-wait || foot"; }
        Mod+E hotkey-overlay-title="Файлы" { spawn "dolphin"; }
        Mod+Space hotkey-overlay-title="Запуск программ" { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
        Mod+D hotkey-overlay-title=null { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
        Mod+S hotkey-overlay-title="Центр управления" { spawn "noctalia" "msg" "panel-toggle" "control-center"; }
        Super+Alt+L hotkey-overlay-title="Заблокировать" { spawn "noctalia" "msg" "session" "lock"; }
        Mod+Shift+Q hotkey-overlay-title="Закрыть все окна" { spawn "sh" "${config.xdg.configHome}/niri/close-all.sh"; }

        // Звук и яркость — через Noctalia, с экранной индикацией
        XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia" "msg" "volume-up"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia" "msg" "volume-down"; }
        XF86AudioMute        allow-when-locked=true { spawn "noctalia" "msg" "volume-mute"; }
        XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "noctalia" "msg" "brightness-up"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "noctalia" "msg" "brightness-down"; }

        XF86AudioPlay allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioStop allow-when-locked=true { spawn-sh "playerctl stop"; }
        XF86AudioPrev allow-when-locked=true { spawn-sh "playerctl previous"; }
        XF86AudioNext allow-when-locked=true { spawn-sh "playerctl next"; }

        // Обзор и окна
        Mod+O repeat=false { toggle-overview; }
        Mod+Q repeat=false { close-window; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+L     { move-column-right; }

        Mod+Home      { focus-column-first; }
        Mod+End       { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+H     { focus-monitor-left; }
        Mod+Shift+J     { focus-monitor-down; }
        Mod+Shift+K     { focus-monitor-up; }
        Mod+Shift+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        // Рабочие столы
        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }

        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+U         { move-workspace-down; }
        Mod+Shift+I         { move-workspace-up; }

        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }

        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        // Колонки и размеры
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        Mod+R       { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-column-width-back; }
        Mod+Ctrl+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R  { reset-window-height; }

        Mod+F       { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+M       { maximize-window-to-edges; }
        Mod+Ctrl+F  { expand-column-to-available-width; }
        Mod+C       { center-column; }
        Mod+Ctrl+C  { center-visible-columns; }

        Mod+Minus       { set-column-width "-10%"; }
        Mod+Equal       { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        Mod+V       { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }
        Mod+W       { toggle-column-tabbed-display; }

        // Скриншоты
        Print      { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print  { screenshot-window; }

        // Служебное
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        Mod+Shift+E { quit; }
        Ctrl+Alt+Delete { quit; }
        Mod+Shift+P { power-off-monitors; }
    }
  '';

  # Сборка с проверкой: ошибка в KDL = ошибка сборки, а не сломанный niri
  checkedConfig =
    pkgs.runCommand "niri-config.kdl"
      {
        nativeBuildInputs = [ pkgs.niri ];
        passAsFile = [ "kdl" ];
        kdl = niriConfig;
      }
      ''
        cp "$kdlPath" "$out"
        export HOME="$TMPDIR" XDG_CONFIG_HOME="$TMPDIR"
        niri validate --config "$out"
      '';
in
{
  xdg.configFile."niri/config.kdl".source = checkedConfig;
}
