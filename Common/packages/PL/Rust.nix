{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustc
    rustup  # includes rustfmt, rust-analyzer, cargo
  ];
}
