{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ruby
    pry
    ruby-lsp
    rubyPackages.rails
  ];
}
