{
  description = "A minimal flake template that you can adapt to your own project";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
  # verilator broken in 26.05 (flex/FlexLexer.h mismatch); take it from 25.11
  inputs.nixpkgs-old.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2511";
  inputs.pwndbg.url = "github:pwndbg/pwndbg";

  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.nixpkgs) lib;

      supportedSystems = [
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        lib.genAttrs supportedSystems (
          system:
          f {
            inherit system;
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            pkgs-old = import inputs.nixpkgs-old { inherit system; };
	    pwn = inputs.pwndbg.packages.${system};
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs, pkgs-old, system, pwn }:
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              self.formatter.${system}
              pkgs-old.verilator
	      pwn.pwndbg-lldb
	      iverilog
            ];
          };
        }
      );

      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt);
    };
}
