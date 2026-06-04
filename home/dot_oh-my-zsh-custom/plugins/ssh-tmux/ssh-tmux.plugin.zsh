function ssh-tmux {
    local remote_host=$1
    local session_name=$2

    ssh -t "$remote_host" "tmux -u new-session -A -s $session_name \; set -g status off"
}
