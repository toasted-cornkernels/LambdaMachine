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
    };
  };

  outputs = { self, nixpkgs-darwin, nixpkgs-unstable, darwin
    , home-manager-darwin, ... }@inputs: {
      darwinConfigurations = {
        iMac27Intel = darwin.lib.darwinSystem rec {
          system = "x86_64-darwin";
          specialArgs = {
            inherit inputs;
            lambdaMachineDir = "LambdaMachine";
          };
          modules = [
            ./Darwin/iMac27Intel/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee = import ./Darwin/iMac27Intel/home.nix;
            }
            {
              home-manager-darwin.extraSpecialArgs = specialArgs;
            }
          ];
        };
        MacBook14M1Max = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/MacBook14M1Max/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee =
                import ./Darwin/MacBook14M1Max/home.nix;
            }
          ];
        };
        WorkMacBook1 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/WorkMacBook1/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee = import ./Darwin/WorkMacBook1/home.nix;
            }
          ];
        };
        WorkMacBook2 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/WorkMacBook2/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee = import ./Darwin/WorkMacBook2/home.nix;
            }
          ];
        };
      };
    };
}
