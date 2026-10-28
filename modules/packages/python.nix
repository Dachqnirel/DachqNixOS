# Python для data science — одно окружение со всеми библиотеками
{ pkgs, ... }:

let
  pythonDataScience = pkgs.python3.withPackages (ps: with ps; [
    jupyter
    notebook
    ipykernel
    pandas
    numpy
    matplotlib
    scikit-learn
    catboost
  ]);
in
{
  environment.systemPackages = [ pythonDataScience ];
}
