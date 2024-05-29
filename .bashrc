##########################################
# Configurations / Functions
##########################################
# silence deprecation warnings
export BASH_SILENCE_DEPRECATION_WARNING=1

# set path to homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

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

# make an alias for each project in the projects folder
for dir in ~/projects/*/
do
    dir=${dir%*/}
    eval "alias ${dir##*/}='code ~/projects/${dir##*/}'"
done

alias shell_config='code ~/.shell_config'

##########################################
# Docker
##########################################
alias dcub='docker-compose up --build'
alias dcd='docker-compose down'
alias dsp='docker system prune -af'

dcu () { \
  clear; \
  docker-compose up "${1:-$DEFAULT_DOCKER_SERVICE}" \
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
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  python x.py; \
}

dct () { \
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

dcmigrate () { \
  unset ENVIRONMENT; \
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  python manage.py migrate;
}

dcmm () { \
  clear; \
  docker compose run --rm --no-deps "${1:-$DEFAULT_DOCKER_SERVICE}" \
  python manage.py makemigrations;
}

dcmigratezero () { \
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
alias gl='git log --oneline -15'
alias gt='git for-each-ref --sort=-creatordate --format "%(refname:strip=2)" refs/tags'


##########################################
# Hubflow
##########################################
alias hf='git hf'

alias hff='hf feature'
alias hffs='hff start'
alias hfff='hff finish'
alias hffc='hff cancel'

alias hfh='hf hotfix'
alias hfhs='hfh start'
alias hfhf='hfh finish'
alias hfhc='hfh cancel'

alias hfr='hf release'
alias hfrs='hfr start'
alias hfrf='hfr finish'
alias hfrc='hfr cancel'

alias hfu='hf update'
alias hfp='hf push'

alias cowboy='ga .; gc -; hfp'


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
### set terraform variables for service db passwords
export TF_VAR_listing_database_password=ALREADY_SET
export TF_VAR_email_forwarder_database_password=ALREADY_SET
export TF_VAR_show_database_password=ALREADY_SET
export TF_VAR_speculation_database_password=ALREADY_SET

tga () { cd "$2"; terragrunt "$1"; cd ..; }
alias tg="tga"


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