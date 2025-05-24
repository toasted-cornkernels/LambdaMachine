{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # deno
    yarn
    nodejs
    corepack
    typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
  ];
}

