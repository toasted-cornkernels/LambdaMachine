{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # deno
    nodejs_20
    yarn
    corepack
    typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
  ];
}

