{
  description = "A simple command line frontend for OpenRazer";
  outputs = { self, nixpkgs }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
      });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          rzr =
            pkgs.python3Packages.buildPythonPackage {
              pname = "rzr";
              version = "main";
              src = self;
              propagatedBuildInputs = with pkgs; [
                python3Packages.colour
                python3Packages.openrazer
                python3Packages.toml
              ];
            };
          default = self.packages.${system}.rzr;
        }
      );

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          rzr = pkgs.mkShell {
            buildInputs = with pkgs; [
              python3
              python3Packages.colour
              python3Packages.openrazer
              python3Packages.toml

            ];
          };
          default = self.devShells.${system}.rzr;
        }
      );
    };
}
