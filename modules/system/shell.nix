# Оболочка и редактор по умолчанию
{
  programs.zsh = {
    enable = true;
    shellInit = "echo 'Welcome to NixOS!'";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;   # $EDITOR = nvim
  };
}
