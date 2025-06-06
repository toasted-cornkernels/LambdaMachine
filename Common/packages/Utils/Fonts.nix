{ pkgs, ... }: {
  home.packages = with pkgs; [
    font-awesome
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    d2coding
    # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "D2Coding" ]; })
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.d2coding
  ];
}
