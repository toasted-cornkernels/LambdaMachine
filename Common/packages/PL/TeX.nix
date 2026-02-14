{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (texliveBasic.withPackages (ps: [
      ps.texliveonfly
      ps.dvisvgm
    ]))
    texlab
  ];
}
