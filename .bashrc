##########################################
# Configurations / Functions
##########################################
# silence deprecation warnings
export BASH_SILENCE_DEPRECATION_WARNING=1

# set path to homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# set path to pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"

# set path to pycharm
export PATH="/Applications/PyCharm.app/Contents/MacOS:$PATH"

# set the default docker service
export DEFAULT_DOCKER_SERVICE="$(basename $PWD)"

# get git branch
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "["${ref#refs/heads/}"]"
}

# check environment
prompt_environment_confirmation() {
  if [ -n "$ENVIRONMENT" ]; then
    echo "ENVIRONMENT : $ENVIRONMENT - continue? y/n"
    read -r user_input
    if [ "$user_input" != "y" ]; then
      echo "operation aborted"
      return 1  # Signal to caller that the user did not confirm
    fi
  fi
  return 0  # Signal to caller that it's okay to proceed
}


##########################################
# AWS
##########################################
saws () { export AWS_PROFILE="$@"; }
uaws () { unset AWS_PROFILE; }
taws () { \
  clear; \
  echo "AWS_PROFILE: ${AWS_PROFILE:-None}"; \
  echo ""; \
  aws configure list; \
  echo ""; \
  tail -30 ~/.aws/credentials; \
  echo ""; \
  tail -30 ~/.aws/config; \
}
sso () { saws topps; aws sso login --profile "${1:-$AWS_DEFAULT_PROFILE}"; }


##########################################
# Bash/zsh Profile
##########################################
alias obp='open ~/.bashrc'
alias sbp='source ~/.bashrc'

alias ozp='open ~/.zshrc'
alias szp='source ~/.zshrc'


##########################################
# Common Commands
##########################################
alias l='ls -lah'
alias p='pwd'
alias c='clear'
alias ..='cd ../'
alias ...='../..'
alias ....='../../../'


##########################################
# Common Directories
##########################################

# lotus projects
for dir in ~/projects/lotus/*/
do
    dir=${dir%*/}
    eval "alias ${dir##*/}='pycharm ~/projects/lotus/${dir##*/}'"
done

# fanatics projects
for dir in ~/projects/fanatics/*/
do
    dir=${dir%*/}
    eval "alias ${dir##*/}='pycharm ~/projects/fanatics/${dir##*/}'"
done

# personal projects
for dir in ~/projects/personal/*/
do
    dir=${dir%*/}
    eval "alias ${dir##*/}='pycharm ~/projects/personal/${dir##*/}'"
done

alias shell_config='pycharm ~/.shell_config'

##########################################
# Docker
##########################################
alias dcub='docker compose up --build --remove-orphans'
alias dcd='docker compose down'
alias dsp='docker system prune -af'
alias dvp='docker volume prune -f'

dcu () { \
  clear; \
  docker compose up "${1:-$DEFAULT_DOCKER_SERVICE}" --remove-orphans \
}

dca () { \
  clear; \
  docker attach "${1:-$DEFAULT_DOCKER_SERVICE}" \
}

dcssh () { \
  docker compose run --rm --no-deps \
  -e CURRENT_SERVICE="${1:-$DEFAULT_DOCKER_SERVICE}" \
  "${1:-$DEFAULT_DOCKER_SERVICE}" \
  /bin/bash --login; clear; \
}

dcx () { \
  prompt_environment_confirmation || return 1
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  python x.py; \
}

dcdt () { \
  unset ENVIRONMENT; \
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  python manage.py test --keepd "${2:-.}" -v 2; \
}

dcpt () { \
  unset ENVIRONMENT; \
  clear; \
  docker compose run --rm --no-deps "${DEFAULT_DOCKER_SERVICE}" \
  pytest --disable-pytest-warnings -k "${1:-.}" -vv; \
}

dcdm () { \
  unset ENVIRONMENT; \
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  python manage.py migrate;
}

dcdmm () { \
  unset ENVIRONMENT; \
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  python manage.py makemigrations;
}

dcdm-zero () { \
  unset ENVIRONMENT; \
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  python manage.py migrate core zero;
}

dclint() { \
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  flake8 . --show-source --statistics; \
}

# extras
alias db='docker build'
alias dr='docker run'
alias de='docker exec'
alias ds='docker stop'
alias dc='docker container'
alias di='docker images'
alias dps='docker ps'
alias da='docker attach'


##########################################
# Environment Variables
##########################################
ee () {
	if [ -z "$1" ]
	then
		unset ENVIRONMENT; echo "unset ENVIRONMENT"; echo $ENVIRONMENT;
	else
		export ENVIRONMENT="$1"; echo $ENVIRONMENT;
	fi
}
alias eep='ee production'
alias ees='ee staging'
alias eet='ee testing'


##########################################
# Git
##########################################
alias gb='git branch'
alias gs='git branch; git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m'
alias gca='git commit --amend -Chead'
alias gco='git checkout'
alias gp='git push'
alias gl='git log --oneline -15'
alias gt='git for-each-ref --sort=-creatordate --format "%(refname:strip=2)" refs/tags | head -n 30'

alias gacp='ga .; gc cowboy; gp'

function ngt() {
    local tag_prefix
    local last_tag
    local new_version
    local new_tag
    
    # Fetch the latest tag in the format v1.1.7-xyz-123 or v1.1.07-xyz-123
    last_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

    if [[ $last_tag =~ ^(v[0-9]+\.[0-9]+\.[0-9]+)-.*$ ]]; then
        tag_prefix=${match[1]}
        # Extract the version number and increment it
        new_version=$(echo $tag_prefix | awk -F. '{print $1 "." $2 "." $3+1}')
        # Create the new tag with the provided string argument
        new_tag="${new_version}-$1"
        # Copy the new tag to the clipboard
        echo -n $new_tag | pbcopy
        echo "New tag: $new_tag copied to clipboard."
    else
        echo "No valid tag found."
    fi
}


##########################################
# Hubflow
##########################################
alias hf='git hf'

alias hffs='hf feature start'
alias hffc='hf feature cancel'
alias hfff='hf feature finish'

alias hfhs='hf hotfix start'
alias hfhc='hf hotfix cancel'
alias hfhf='hf hotfix finish $(git rev-parse --abbrev-ref HEAD | sed "s/^hotfix\///")'

alias hfrs='hf release start'
alias hfrc='hf release cancel'
alias hfrf='hf release finish $(git rev-parse --abbrev-ref HEAD | sed "s/^release\///")'

alias hfu='hf update'
alias hfp='hf push'


##########################################
# Linting
##########################################
alias lint='flake8 . --exclude venv --show-source --statistics --ignore=E501'


##########################################
# Python / PIP
##########################################

# pip uninstall all
alias pipu='clear; source venv/bin/activate; pip uninstall -y -r <(pip freeze)'

# pip install all
alias pipi='clear; source venv/bin/activate; pip install -r requirements.txt'


##########################################
# Testing
##########################################
pyt () { clear; python -m pytest --disable-pytest-warnings "$@" -vv; }
pytc () { clear; coverage run -m pytest --disable-pytest-warnings "$@" -vv; coverage html; }
pytr () { clear; coverage report; }


##########################################
# Terraform
##########################################
alias tf='terraform'
alias tfa='tf apply'
alias tfaf='tfa -auto-approve'

tg_func () { cd ./infrastructure; cd "$2"; terragrunt "$1"; cd ../..; }
alias tg="tg_func"

tga_func () { cd ./infrastructure; cd "$1"; terragrunt apply; cd ../..; }
alias tga="tga_func"

tgaf_func () { cd ./infrastructure; cd "$1"; terragrunt apply -auto-approve; cd ../..; }
alias tgaf="tgaf_func"


##########################################
# Virtual Env
##########################################
alias venv='if [ -d "venv" ]; then source venv/bin/activate; else python3 -m venv venv && source venv/bin/activate; fi'
alias d='deactivate'


##########################################
# Zappa
##########################################
zt () { clear; zappa tail "$@" --since 1s; }

# End of File
