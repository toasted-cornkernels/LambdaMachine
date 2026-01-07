{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # deno
    yarn
    nodejs
    typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
    vscode-langservers-extracted
  ];
}

