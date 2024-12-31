{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "[░▒▓](#a3aed2)[  ](bg:#a3aed2 fg:#090c0c)[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#394260)$git_branch[](fg:#394260 bg:#212736)$nodejs$rust$golang[](fg:#212736 bg:#1d2230)$time[ ](fg:#1d2230)";
      character = {
        format = "$symbol";
        error_symbol = "[ ](bold fg:red bg:#19172C)";
        success_symbol = "[ ](bold fg:green bg:#19172C)";
      };

      directory = {
        format = "[   $path ](fg:#e3e5e5 bg:#769ff0)(fg:#2D2B40)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        format = "[  $branch$all_status$ahead_behind ](fg:#769ff0 bg:#394260)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      jobs = {
        symbol = " 󰠜 ";
        style = "(fg:#769ff0 bg:#394260)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
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
