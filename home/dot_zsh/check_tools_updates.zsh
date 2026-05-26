# shellcheck shell=bash

source "${HOME}/.zsh/async.zsh"
async_init

# Check for outdated mise itself and tools.
#
# Return codes:
#  * 0 = everything is up-to-date
#  * 1 = mise is outdated
#  * 2 = some tools are outdated
#  * 3 = mise and some tools are outdated
#  * 10 = mise invocation returned an error
function _mise_check_outdated {
    local outdated_code=0

    # Check for mise update.
    local mise_version
    mise_version=$(mise version --json)
    if (( $? != 0 )); then
        return 10
    fi
    if jq --exit-status '(.version | split(" ")[0]) != (.latest)' <<<"${mise_version}"; then
        (( outdated_code += 1 ))
    fi

    # Check for tools updates.
    local outdated_tools
    outdated_tools=$(mise outdated --json)
    if (( $? != 0 )); then
        return 10
    fi
    if jq --exit-status 'length != 0' <<<"${outdated_tools}"; then
        (( outdated_code += 2 ))
    fi

    return ${outdated_code}
}

function _mise_check_callback {
    local return_code="$2"
    local stderr="$5"

    if (( return_code == 0 )); then
        return
    fi

    zle -I

    case $return_code in
        1) echo "mise is outdated, please run \`mise self-update\`" ;;
        2) echo "some mise tools are outdated, please run \`mise upgrade\`" ;;
        3)
            echo "mise is outdated, please run \`mise self-update\`"
            echo "some mise tools are outdated, please run \`mise upgrade\`"
            ;;
        10)
            echo "mise invocation error:"
            echo "${stderr}"
            ;;
        *) echo "unknown return code when checking mise updates: ${return_code}" ;;
    esac
}

async_start_worker check_tools_updates

async_register_callback check_tools_updates _mise_check_callback

# Asynchronously check for `mise` tools updates.
async_job check_tools_updates _mise_check_outdated
