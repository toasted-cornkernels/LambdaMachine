{
  description = "LambdaMachine";
  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = { self, nixpkgs-darwin, nixpkgs, nix-darwin
    , home-manager-darwin, home-manager, ... }@inputs: {
      darwinConfigurations = {
        iMac27Intel = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/iMac27Intel/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee = import ./Darwin/iMac27Intel/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                lambdaMachineDir = "LambdaMachine";
              };
            }
          ];
        };
        MacBook14M1Max = nix-darwin.lib.darwinSystem {
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
              home-manager.extraSpecialArgs = {
                inherit inputs;
                lambdaMachineDir = "LambdaMachine";
              };
            }
          ];
        };
        WorkMacBook1 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/WorkMacBook1/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee = import ./Darwin/WorkMacBook1/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                lambdaMachineDir = "LambdaMachine";
              };
            }
          ];
        };
        WorkMacBook2 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/WorkMacBook2/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee = import ./Darwin/WorkMacBook2/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                lambdaMachineDir = "LambdaMachine";
              };
            }
          ];
        };
        CheapChromeBook = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            ./ChromeOS/home.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            lambdaMachineDir = "LambdaMachine";
          };
        };
      };
    };
}
