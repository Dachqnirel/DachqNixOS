# Claude Code в цветах системы: тема «Machine» из общей палитры.
# Включить один раз внутри Claude Code: /theme → Machine
let
  p = (import ../theme/palette.nix).hex;
in
{
  home.file.".claude/themes/machine.json".text = builtins.toJSON {
    name = "Machine";
    base = "dark";
    overrides = {
      # Акцент — тот же красный, что у рамок niri и TrackPoint
      claude = p.base08;
      claudeShimmer = "#c9605b";
      briefLabelClaude = p.base08;
      briefLabelYou = p.base0D;

      # Текст: графит и серые
      text = p.base05;
      inverseText = p.base00;
      inactive = p.base04;
      inactiveShimmer = p.base05;
      subtle = p.base03;
      suggestion = p.base0D;
      remember = p.base0E;

      # Рамки: поле ввода серое, запросы разрешений — бронза Механикус
      promptBorder = p.base03;
      promptBorderShimmer = p.base04;
      permission = p.base0F;
      permissionShimmer = p.base09;
      bashBorder = p.base0F;
      planMode = p.base0C;
      autoAccept = p.base0B;

      # Состояния
      success = p.base0B; # зелёный DOOM
      error = p.base08;
      warning = p.base09;
      warningShimmer = p.base0A;

      # Изменения в файлах: приглушённые фоны, слова — ярче
      diffAdded = "#26301c";
      diffRemoved = "#3a1f1e";
      diffAddedDimmed = "#1f241a";
      diffRemovedDimmed = "#2a1c1b";
      diffAddedWord = "#3d4d29";
      diffRemovedWord = "#5c2a28";

      # Фоны сообщений
      userMessageBackground = p.base01;
      userMessageBackgroundHover = p.base02;
      bashMessageBackgroundColor = p.mid;
      memoryBackgroundColor = p.mid;
      selectionBg = p.base02;

      # Шкала /usage
      rate_limit_fill = p.base08;
      rate_limit_empty = p.base02;
    };
  };
}
