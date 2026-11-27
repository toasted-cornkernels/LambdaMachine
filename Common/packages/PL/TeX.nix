{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (texliveBasic.withPackages (ps: [
      ps.texliveonfly
      ps.dvisvgm
      # pandoc's default LaTeX template via xelatex (ELispMachine's elfeed-extras.el)
      ps.xetex
      ps.fontspec
      ps.unicode-math
      ps.lm-math
      ps.xecjk
      ps.ctex
      ps.geometry
      ps.setspace
      ps.hyperref
      ps.bookmark
      ps.xcolor
      ps.booktabs
      ps.etoolbox
      ps.fancyvrb
      ps.upquote
      ps.microtype
      ps.parskip
      ps.footnotebackref
      ps.framed
      ps.soul
      ps.ulem
      ps.csquotes
      ps.caption
      ps.float
      ps.iftex
      ps.xurl
      ps.mdwtools
    ]))
    texlab
  ];
}
