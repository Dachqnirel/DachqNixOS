# foot и fastfetch в палитре системы
{ ... }:

let
  p = import ../theme/palette.nix;
  ansi = p.ansi;
  idx = builtins.elemAt;

  # Ящик fastfetch: ┌─── MACHINE SPIRIT ───┐ — ширина 72 символа
  line = "────────────────────────────"; # 28 символов
  label = " MACHINE SPIRIT "; # 16 символов
  bottom = "────────────────"; # 16 символов, под надписью
in
{
  # ── foot ────────────────────────────────────────────────────────────
  programs.foot = {
    enable = true;
    server.enable = true; # сервер стартует с сессией → окна открываются мгновенно

    settings = {
      main = {
        font = "${p.font.mono}:size=${toString p.font.termSize}";
        pad = "16x14";
      };
      csd.preferred = "none";
      cursor = {
        style = "block";
        blink = "no";
      };
      mouse.hide-when-typing = "yes";

      colors-dark = {
        alpha = "0.94";
        background = p.base00;
        foreground = p.base05;
        cursor = "${p.base00} ${p.base08}"; # красный блочный курсор
        selection-background = p.base02;
        selection-foreground = p.base07;

        regular0 = idx ansi 0;
        regular1 = idx ansi 1;
        regular2 = idx ansi 2;
        regular3 = idx ansi 3;
        regular4 = idx ansi 4;
        regular5 = idx ansi 5;
        regular6 = idx ansi 6;
        regular7 = idx ansi 7;
        bright0 = idx ansi 8;
        bright1 = idx ansi 9;
        bright2 = idx ansi 10;
        bright3 = idx ansi 11;
        bright4 = idx ansi 12;
        bright5 = idx ansi 13;
        bright6 = idx ansi 14;
        bright7 = idx ansi 15;

        # Дополнительные цвета base16 (используются fastfetch и neovim)
        "16" = p.base09;
        "17" = p.base0F;
        "18" = p.base01;
        "19" = p.base02;
        "20" = p.base04;
        "21" = p.base06;
      };
    };
  };

  # ── fastfetch: тот же ящик, что тебе понравился, в палитре ──────────
  programs.fastfetch = {
    enable = true;
    settings = {
      general.detectVersion = false;
      logo.type = "none";
      display = {
        separator = " ─  ";
        color = {
          separator = "31"; # красный
          keys = "38;5;20"; # серый подписей (base04)
          output = "default";
        };
        key = {
          type = "both";
          paddingLeft = 4;
        };
      };
      modules = [
        {
          type = "title";
          format = "                              {#31}{user-name}{#90}@{#37}{host-name}";
        }
        "break"
        {
          type = "custom";
          format = "{#90}┌${line}{#1;31}${label}{#0;90}${line}┐";
        }
        "break"
        { type = "os"; key = "OS          "; }
        { type = "host"; key = "MACHINE     "; }
        { type = "kernel"; key = "KERNEL      "; }
        { type = "uptime"; key = "UPTIME      "; }
        { type = "display"; key = "DISPLAY     "; compactType = "original-with-refresh-rate"; }
        { type = "wm"; key = "WM          "; }
        { type = "shell"; key = "SHELL       "; }
        { type = "terminal"; key = "TERMINAL    "; }
        {
          type = "cpu";
          key = "CPU         ";
          format = "{name} ({cores-physical}C/{cores-logical}T)";
        }
        {
          type = "custom";
          key = "GPU         ";
          keyIcon = "󰢮";
          format = "RTX 3060 Mobile + Iris Xe";
        }
        { type = "memory"; key = "MEMORY      "; }
        { type = "disk"; key = "DISK        "; folders = "/"; }
        { type = "battery"; key = "BATTERY     "; }
        "break"
        {
          type = "custom";
          format = "{#90}└${line}${bottom}${line}┘";
        }
        "break"
        {
          type = "colors";
          paddingLeft = 28;
          symbol = "block";
        }
      ];
    };
  };
}
