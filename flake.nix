{
  description = "Nixos config flake";
  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = { self, nixpkgs-darwin, nixpkgs-unstable, darwin, home-manager-darwin
    , ... }@inputs: {
      darwinConfigurations = {
        MacBook14M1Max = darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          system = "aarch64-darwin";
          modules = [
            ./Darwin/MacBook14M1Max/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager-darwin.useGlobalPkgs = true;
              home-manager-darwin.useUserPkgs = true;
              home-manager-darwin.users.jslee =
                import ./Darwin/MacBook14M1Max/home.nix;
            }
          ];
        };
      };
    };
}
