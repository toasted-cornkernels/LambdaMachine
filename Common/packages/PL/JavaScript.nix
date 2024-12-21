{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # deno
    nodejs
    yarn
    corepack
    typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
  ];
}

