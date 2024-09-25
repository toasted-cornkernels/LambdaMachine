{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lua
    lua-language-server
    (lua5_3_compat.withPackages (ps:
        with ps; [
          fennel
          luafilesystem
          readline
          luasocket
          (lua5_3.pkgs.buildLuarocksPackage {
            pname = "jeejah";
            lua = lua5_3;
            version = "0.3.2-1";
            knownRockspec = (pkgs.fetchurl {
              url = "https://luarocks.org/jeejah-0.3.2-1.rockspec";
              sha256 = "sha256-Ouj+umHFOLtGwwMKochvG1fqIyRMdPzXg9039jD/bPk=";
            }).outPath;
            disabled = luaOlder "5.1";
            src = fetchFromGitLab {
              owner = "technomancy";
              repo = "jeejah";
              rev = "1555350e1e5eb77625334db1fba3c79b8c2c30a2";
              sha256 = "sha256-DyJJprTj9WjnhCC5CqudObLuae43zJD0VY9svGbqz10=";
            };
            propagatedBuildInputs = [ luasocket ];
            meta = { };
          })
        ]))
  ];
}

