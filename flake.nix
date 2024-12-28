{
  description = "LambdaMachine";
  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    }
  };

  outputs = { self, nixpkgs-darwin, nixpkgs-unstable, darwin, home-manager-darwin
    , ... }@inputs: {
      darwinConfigurations = {
        iMac27Intel = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/iMac27Intel/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee =
                import ./Darwin/iMac27Intel/home.nix;
            }
          ];
        };
        MacBook14M1Max = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/MacBook14M1Max/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee =
                import ./Darwin/MacBook14M1Max/home.nix;
            }
          ];
        };
      };
    };
}
