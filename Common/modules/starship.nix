{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$nix_shell$directory[](fg:#769ff0 bg:#394260)$git_branch[](fg:#394260 bg:#212736)$nodejs$rust$golang[](fg:#212736 bg:#1d2230)$time[ ](fg:#1d2230)";
      character = {
        format = "$symbol";
        error_symbol = "[ ](bold fg:red bg:#19172C)";
        success_symbol = "[ ](bold fg:green bg:#19172C)";
      };

      directory = {
        format = "[   $path ](fg:#2D2B40 bg:#769ff0)";
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
        style = "[[ $symbol ](fg:#769ff0 bg:#394260)]";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[   $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };

      hostname = {
        ssh_only = true;
        format = "[ $hostname ](italic fg:bright-white bg:#19172C)";
      };

      nix_shell = {
        disabled = false;
        heuristic = true;
        symbol = "❄";
        format = "[ $symbol $state( \($name\))](bg:#a3aed2 fg:#1d2230)[](fg:#a3aed2 bg:#769ff0)";
      };

      # nix_shell_legacy = {
      #   disabled = false;
      #   heuristic = false;
      #   symbol = "❄";
      #   format = "[ $symbol $state( \($name\))](bg:#a3aed2 fg:#1d2230)[](fg:#a3aed2 bg:#769ff0)";
      # };
    };
  };
}
