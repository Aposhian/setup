source ~/.setup

export ZSH="$SETUP_HOME/zsh/ohmyzsh"
ZSH_THEME="agnoster"
DEFAULT_USER="adam"

plugins=(git)

source $ZSH/oh-my-zsh.sh
source $SETUP_HOME/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# User configuration

export LANG=en_US.UTF-8
export EDITOR='vim'
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/home/adam/.local/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/adam/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/adam/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/adam/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/adam/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Handy function for running calculations on the command line
function calc() {
        echo "import numpy as np
print($@)" | python3
}
alias calc='noglob calc'

source /opt/ros/foxy/setup.zsh
source <(npm completion)
source /usr/share/vcstool-completion/vcs.zsh

alias ls='ls -a'
