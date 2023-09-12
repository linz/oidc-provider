let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  python = pkgs.python310;

  poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
    inherit python;
    projectDir = builtins.path {
      path = ./.;
      name = "oidc-provider";
    };
    preferWheels = true;
    overrides = pkgs.poetry2nix.overrides.withDefaults (self: super: {
      aws-cdk-asset-node-proxy-agent-v6 = super.aws-cdk-asset-node-proxy-agent-v6.overridePythonAttrs (
        # Upstream fix: https://github.com/nix-community/poetry2nix/pull/1306
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.setuptools ];
        }
      );
    });
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
        python3 = python;
      })
      pkgs.which
    ];
  }
)
