{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dotnet-sdk_8
    # openjdk8-bootstrap
    # jdk11
    jdk
  ];
}

