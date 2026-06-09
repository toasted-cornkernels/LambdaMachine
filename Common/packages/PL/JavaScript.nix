{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # deno
    yarn
    nodejs
    typescript
    typescript-language-server
    prettier
    vscode-langservers-extracted
  ];
}

