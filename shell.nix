{ pkgs ? import
    (
      fetchTarball
        {
          name = "22.05";
          url = "https://github.com/NixOS/nixpkgs/archive/ce6aa13369b667ac2542593170993504932eb836.tar.gz";
          sha256 = "0d643wp3l77hv2pmg2fi7vyxn4rwy0iyr8djcw1h5x72315ck9ik";
        })
    { }
}:
let
  python = pkgs.python3;
  projectDir = builtins.path {
    path = ./.;
    name = "oidc-provider";
  };

  poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
    inherit python projectDir;
    overrides = pkgs.poetry2nix.overrides.withDefaults (self: super: {
      mypy = super.mypy.overridePythonAttrs (old: {
        patches = [ ];
        MYPY_USE_MYPYC = false;
      });
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
        inherit python;
      })
      pkgs.which
    ];
  }
)
