{ pkgs, ... }:
{
  home.packages = with pkgs; [
    haskellPackages.ghc
    haskellPackages.haskell-language-server
  ];
}
