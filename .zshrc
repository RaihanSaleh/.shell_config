# source .bashrc
source ~/.bashrc

# enable Zsh completion
autoload -Uz compinit && compinit

# enable prompt substitution
setopt PROMPT_SUBST

# set the prompt
export PS1='$(tput bold)%~$(tput sgr0) $(parse_git_branch)
$ '

source /Users/rsaleh/.docker/init-zsh.sh || true # Added by Docker Desktop
