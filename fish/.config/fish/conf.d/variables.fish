if set -q SSH_CONNECTION
    set -gx EDITOR vim
else
    set -gx EDITOR nvim
end

set -gx ANDROID_HOME $HOME/Android/Sdk

fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $HOME/.dotfiles/commands

set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

if type -q fnm
    fnm env --use-on-cd --corepack-enabled | source
end

