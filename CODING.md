## Development

Prerequisites:

- Python 3.6 through 3.9 (this can be changed in `.python-version` and `pyproject.toml`)
- [Poetry](https://python-poetry.org/docs/#installation)

Optional dependencies:

- [Pyenv](https://github.com/pyenv/pyenv) to use the reference Python version in `pyproject.toml` with a simple `pyenv install`

Install the project dependencies:

```bash
poetry install
```

Install commit-msg git hook. It runs on every local commit to check if the commit message conforms to the convention specified in `.gitlint`

```bash
pre-commit install --hook-type commit-msg --overwrite
pre-commit install --hook-type=pre-commit --overwrite
```
