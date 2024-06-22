{ ... }:
{
  programs.zsh = {
    shellAliases = {
      wifi = "networksetup -setairportpower en0";
      wifistatus = "networksetup -getairportpower en0";
      battery = "pmset -g batt";
      ws = "wifistatus; blueutil -p; battery";
    };
  };
}
