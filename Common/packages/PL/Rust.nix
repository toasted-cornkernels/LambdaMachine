{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustc
    # rustup
    rustfmt
    rust-analyzer
  ];
}
