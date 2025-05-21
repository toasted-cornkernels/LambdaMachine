{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # deno
    yarn
    corepack
    typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
  ];
}

