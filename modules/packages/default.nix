# Программы, разложенные по смыслу.
# Новую программу добавляй в подходящий файл, а не сюда.
{
  imports = [
    ./cli.nix
    ./apps.nix
    ./dev.nix
    ./python.nix
    ./latex.nix
    # ./craftapps.nix   # раскомментируй, когда добавишь nix-craftapps во flake.nix
  ];
}
