# shellcheck shell=bash

source "${HOME}/.zsh/async.zsh"
async_init

async_start_worker check_tools_updates

function _mise_check_callback {
    local return_code="$2"
    local output="$3"
    local stderr="$5"

    if (( return_code != 0 )); then
        zle -I
        echo "Checking mise outdated packages failed:"
        echo "${stderr}"
    fi

    if [[ -n "${output}" ]]; then
        zle -I
        echo "mise packages updates available:"
        echo "${output}"
    fi
}

async_register_callback check_tools_updates _mise_check_callback

# Asynchronously check for `mise` tools updates.
async_job check_tools_updates mise outdated
