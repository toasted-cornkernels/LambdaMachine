{ pkgs, ... }: {
  home.packages = with pkgs; [
    lua-language-server
    # (lua5_3_compat.withPackages (ps:
    #   with ps; [
    #     fennel
    #     luafilesystem
    #     readline
    #     luasocket
    #     luarocks
    #   ]))
    lua
    fennel
    luafilesystem
    readline
    luasocket
    luarocks
    stylua
  ];
}

