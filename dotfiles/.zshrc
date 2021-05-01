export ZSH="/home/adam/.oh-my-zsh"
ZSH_THEME="agnoster"
DEFAULT_USER="adam"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export LANG=en_US.UTF-8
export EDITOR='vim'
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/usr/local/go/bin"

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

source /opt/ros/foxy/setup.bash
source <(npm completion)