{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup  # includes rustc, rustfmt, rust-analyzer, cargo
  ];
}
