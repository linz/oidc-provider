#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail

usage() {
    cat >&2 << 'EOF'
./reset-dev-env.bash --all
./reset-dev-env.bash [--delete] [--hooks] [--python]
./reset-dev-env.bash --help

`--all` implies `--delete --hooks --python`.
EOF
}

arguments="$(getopt --options '' \
    --longoptions all,delete,help,hooks,python --name "$0" -- "$@")"
eval set -- "$arguments"
unset arguments

while true
do
    case "$1" in
        --all)
            delete=1
            hooks=1
            python=1
            shift
            ;;
        --delete)
            delete=1
            shift
            ;;
        --help)
            usage
            exit
            ;;
        --hooks)
            hooks=1
            shift
            ;;
        --python)
            python=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            printf 'Not implemented: %q\n' "$1" >&2
            exit 1
            ;;
    esac
done

if [[ -z "${hooks-}" ]] \
    && [[ -z "${python-}" ]]
then
    usage
    exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ -n "${delete-}" ]]
then
    echo "Cleaning Git repository"
    git clean -d --exclude='.idea' --force -x
fi

if [[ -n "${python-}" ]]
then
    if [[ -n "${delete-}" ]]
    then
        echo "Removing Python packages"
        rm --force --recursive ./.venv
    fi

    echo "Installing Python packages"
    poetry env use "$(cat .python-version)"
    poetry install \
        --no-root \
        --sync
fi

if [[ -n "${hooks-}" ]]
then
    echo "Installing Git hooks"

    # shellcheck source=/dev/null
    . .venv/bin/activate

    pre-commit install --hook-type=commit-msg --overwrite
    pre-commit install --hook-type=pre-commit --overwrite
fi
