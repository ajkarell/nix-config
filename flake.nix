{
  inputs = {
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixos-wsl  = {
      url = "github:nix-community/NixOS-WSL/main"; 
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil/2023-08-09";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      moduleNil = {
        environment.systemPackages = [ inputs.nil.packages.x86_64-linux.nil ];
      };
      modulePinRegistry = {
        nix.nixPath = [
          "nixpkgs=/etc/channels/nixpkgs"
          "unstable=/etc/channels/unstable"
          "nixos-config=/etc/nixos/configuration.nix"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
        environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
        environment.etc."channels/unstable".source = inputs.unstable.outPath;
        nix.registry.nixpkgs.flake = nixpkgs;
        nix.registry.unstable.flake = nixpkgs;
      };
      modulesShared = [
        home-manager.nixosModules.home-manager
        moduleNil
        modulePinRegistry
        
        ./shared-configuration.nix
        ./home.nix
      ];
      mkSystem =
        let
          system = "x86_64-linux";
        in
        modulesHost: nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
           unstable = import inputs.unstable {
             inherit system;
             config.allowUnfree = true;
            };
          };

          modules = modulesShared ++ modulesHost;
        };
    in
    {
      nixosConfigurations = {
        julen = mkSystem [ ./hosts/julen/configuration.nix ];
      };
    };
}
