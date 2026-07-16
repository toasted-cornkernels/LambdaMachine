{
  description = "LambdaMachine";
  inputs = {
    nixpkgs-darwin-26-05.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    # nixpkgs-darwin-26-05.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin-26-05";
    };
    nix-darwin-intel = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin-26-05";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin-26-05";
    };
    home-manager-darwin-intel = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin-26-05";
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
      nixpkgs-unstable,
      nix-darwin,
      nix-darwin-intel,
      home-manager-darwin,
      home-manager-darwin-intel,
      home-manager,
      nix-on-droid,
      ...
    }@inputs:
    {
      darwinConfigurations = {
        iMac27Intel = nix-darwin-intel.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./Darwin/iMac27Intel/darwin-configuration.nix
            home-manager-darwin-intel.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jslee = import ./Darwin/iMac27Intel/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                lambdaMachineDir = "LambdaMachine";
                nixpkgs-unstable = nixpkgs-unstable;
              };
              home-manager.sharedModules = [
                ./Darwin/common-home.nix
              ];
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
                nixpkgs-unstable = nixpkgs-unstable;
              };
              home-manager.sharedModules = [
                ./Darwin/common-home.nix
              ];
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
                nixpkgs-unstable = nixpkgs-unstable;
              };
              home-manager.sharedModules = [
                ./Darwin/common-home.nix
              ];
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
                nixpkgs-unstable = nixpkgs-unstable;
              };
              home-manager.sharedModules = [
                ./Darwin/common-home.nix
              ];
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
