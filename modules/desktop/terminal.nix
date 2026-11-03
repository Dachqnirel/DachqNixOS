# Терминал, промпт и утилиты
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    foot           # лёгкий терминал, рисует на CPU, NVIDIA не будит
    fastfetch
    wl-clipboard   # wl-copy / wl-paste
    lsof psmisc pciutils powertop   # диагностика: кто держит GPU, lspci, расход
  ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
 
  # foot — терминал по умолчанию для всех программ
  environment.sessionVariables.TERMINAL = "foot";
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "foot.desktop" ];
  };

  programs.starship.enable = true;   # красивый промпт
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
