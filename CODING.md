# Development

## Setup

### Nix

Prerequisites: [nix-direnv](https://github.com/nix-community/nix-direnv)

Run `direnv allow` in the project root to enable the Nix environment every time you `cd` here.

### Non-Nix

Prerequisites:

- [Pyenv](https://github.com/pyenv/pyenv)
- [Poetry](https://python-poetry.org/docs/#installation)

1. Run `pyenv install` to use the reference Python version in `pyproject.toml`.
1. Run `poetry install` to install the project dependencies.

### Common

Run `pre-commit install --hook-type=commit-msg --hook-type=pre-commit --overwrite` to install
pre-commit hooks. They will run linting and formatting when committing changes.
