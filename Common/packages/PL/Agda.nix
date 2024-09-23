{ pkgs, ... }: {
  home.packages = with pkgs; [
    agda
  ];
}
