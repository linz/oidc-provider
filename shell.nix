let
  pkgs =
    import
      (
        fetchTarball (
          builtins.fromJSON (
            builtins.readFile ./nixpkgs.json
          )
        )
      )
      { };
  python = pkgs.python310;

  poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
    inherit python;
    projectDir = builtins.path {
      path = ./.;
      name = "oidc-provider";
    };
    preferWheels = true;
  };
in
poetryEnv.env.overrideAttrs (
  oldAttrs: {
    buildInputs = [
      pkgs.cacert
      pkgs.cargo
      pkgs.gitFull
      pkgs.nodejs
      (pkgs.poetry.override {
        inherit python;
      })
      pkgs.which
    ];
  }
)
