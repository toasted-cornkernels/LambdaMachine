final: prev: {
  lua = prev.lua.override {
    packageOverrides = luafinal: luaprev: {
      jeejah = luafinal.callPackage ({ luaOlder, buildLuarocksPackage, lua, }:
        buildLuarocksPackage {
          pname = "jeejah";
          # lua = lua5_3;
          version = "0.3.2-1";
          knownRockspec = ((import <nixpkgs>).fetchurl {
            url = "https://luarocks.org/jeejah-0.3.2-1.rockspec";
            sha256 = "sha256-Ouj+umHFOLtGwwMKochvG1fqIyRMdPzXg9039jD/bPk=";
          }).outPath;
          disabled = luaOlder "5.1";
          src = (import <nixpkgs>).fetchFromGitLab {
            owner = "technomancy";
            repo = "jeejah";
            rev = "0.3.2-1";
            sha256 = "";
          };
          meta = { };
        });
    };
  };
}
