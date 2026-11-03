# Оболочка и редактор по умолчанию
{
  programs.zsh = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;   # $EDITOR = nvim
  };
}
