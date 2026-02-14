{
  description = "LambdaMachine";
  inputs =
    let
      darwin-version = "25.11";
    in
    {
      nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-${darwin-version}-darwin";
      nixpkgs.url = "github:nixos/nixpkgs/release-${darwin-version}";
      nix-darwin = {
        url = "github:nix-darwin/nix-darwin/nix-darwin-${darwin-version}";
        inputs.nixpkgs.follows = "nixpkgs-darwin";
      };
      home-manager-darwin = {
        url = "github:nix-community/home-manager/release-${darwin-version}";
        inputs.nixpkgs.follows = "nixpkgs-darwin";
      };
      home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nix-on-droid = {
        url = "github:nix-community/nix-on-droid/master";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };
    };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager-darwin,
      home-manager,
      nix-on-droid,
      ...
    }@inputs:
    {
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
              home-manager.users.jslee = import ./Darwin/MacBook14M1Max/home.nix;
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
          specialArgs = {
            inherit inputs;
            username = "jslee";
          };
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
                username = "jslee";
              };
            }
          ];
        };
        WorkMacBook21 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
            username = "jlee4054";
          };
          modules = [
            ./Darwin/WorkMacBook2/darwin-configuration.nix
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jlee4054 = import ./Darwin/WorkMacBook2/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                lambdaMachineDir = "LambdaMachine";
                username = "jlee4054";
              };
            }
          ];
        };
      };
      nixOnDroidConfigurations = {
        ZFold6 = nix-on-droid.lib.nixOnDroidConfiguration {
          pkgs = import nixpkgs { system = "aarch64-linux"; };
          modules = [ ./Android/configuration.nix ];
        };
      };
      homeConfigurations = {
        CheapChromeBook = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./ChromeOS/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            lambdaMachineDir = "LambdaMachine";
          };
        };
      };
    };
}
