{
  description = "Apply lightmaps to Razer devices";

  nixConfig.bash-prompt = "\[\\e[1m\\e[32rzr-develop\\e[0m\]$ ";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {

          # Package

          packages.rzr =

            pkgs.python3Packages.buildPythonApplication {

              name = "rzr";
              src = self;

            };

          defaultPackage = self.packages.${system}.rzr;

          # Development shell

          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              python3
            ];
          };

        }

      );
}
