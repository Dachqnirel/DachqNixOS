# Шрифты (без них пропадают иконки и часть текста)
{ pkgs, ... }:

{
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
  ];
}
