# LaTeX
{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.texlive.withPackages (ps: with ps; [
      scheme-medium
      dvipng
      dvisvgm
      amsmath
    ]))
  ];
}
