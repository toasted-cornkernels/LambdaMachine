{ pkgs, ... }:
{
  home.packages = with pkgs; [
    haskellPackages.stack # TEMP
    haskellPackages.cabal-install # TEMP
    # haskellPackages.ghcup # TEMP
  ];
}
