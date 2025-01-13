{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (ruby_3_4.withPackages (ps:
      with ps; [
        pry
        ruby-lsp
        rails
      ]
    ))
  ];
}
