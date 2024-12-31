{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$character$jobs$directory$git_branch$git_status$nix_shell \n› ";
      character = {
        format = "$symbol";
        error_symbol = "[  ](bold fg:red bg:#19172C)";
        success_symbol = "[  ](bold fg:green bg:#19172C)";
      };

      directory = {
        format = "[   $path ](bg:#2D2B40 fg:bright-white)[](fg:#2D2B40)";
      };

      git_branch = {
        format = "[  $branch ](fg:bright-white)";
      };

      jobs = {
        symbol = " 󰠜 ";
        style = "bright-white";
      };

      hostname = {
        ssh_only = true;
        format = "[ $hostname ](italic fg:bright-white bg:#19172C)";
      };

      nix_shell = {
        format = " [❄ $state( \($name\))](bold blue)";
      };
    };
  };
}
