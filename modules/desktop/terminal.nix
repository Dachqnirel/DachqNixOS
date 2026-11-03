# Терминал, оболочка и промпт. Вид foot и fastfetch — в ../../home/terminal.nix
{ pkgs, ... }:

let
  p = import ../../theme/palette.nix;
  h = p.hex;
in
{
  environment.systemPackages = with pkgs; [
    foot # лёгкий терминал, рисует на CPU, NVIDIA не будит
    fastfetch
    wl-clipboard # wl-copy / wl-paste
    lsof
    psmisc
    pciutils
    powertop # диагностика: кто держит GPU, lspci, расход
  ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # foot — терминал по умолчанию для всех программ
  environment.sessionVariables.TERMINAL = "foot";
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "foot.desktop" ];
  };

  # ── Промпт: тихий, серый, красный только у стрелки ──────────────────
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
      directory = {
        style = "bold ${h.base04}";
        truncation_length = 3;
        read_only = " ro";
        read_only_style = h.base0F;
      };
      git_branch = {
        symbol = "";
        format = "[$symbol$branch]($style) ";
        style = h.base0F;
      };
      git_status.style = h.base09;
      nix_shell = {
        symbol = "nix ";
        format = "[$symbol$state]($style) ";
        style = h.base0D;
      };
      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = h.base03;
      };
      character = {
        success_symbol = "[›](bold ${h.base08})";
        error_symbol = "[›](bold ${h.base09})";
        vimcmd_symbol = "[‹](bold ${h.base0D})";
      };
    };
  };

  programs.zsh = {
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      setopt interactivecomments

      ff() {
        clear
        if (( COLUMNS >= 78 )); then fastfetch; fi
      }

      if [[ $TERM == foot* ]]; then ff; fi
    '';
  };
}
