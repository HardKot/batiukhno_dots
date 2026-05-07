if set -q SSH_CONNECTION
    set -gx EDITOR vim
else
    set -gx EDITOR nvim
end

# 2. Android
set -gx ANDROID_HOME $HOME/Android/Sdk

# 3. Красивое добавление в PATH (без всяких $PATH:...)
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $HOME/Scripts/commands

# 4. SSH Agent
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

# 5. FNM (Fast Node Manager) вместо NVM
if type -q fnm
    fnm env --use-on-cd --corepack-enabled | source
end

# 6. Starship Prompt
if type -q starship
    starship init fish | source
end
