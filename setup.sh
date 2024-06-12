### Homebrew ###############################
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"
############################################


### Python and pip #########################
echo "Installing Python..."
brew install python
############################################


### zsh ####################################
echo "Installing zsh..."
brew install zsh

chsh -s /bin/zsh
############################################


### git ####################################
echo "Installing git..."
brew install git

# configure git
git config --global user.name "Raihan Saleh"
git config --global user.email "raihan.saleh@gmail.com"

# generate SSH key
ssh-keygen -t rsa -b 4096 -C "raihan.saleh@gmail.com" -f ~/.ssh/id_rsa -N ""
eval "$(ssh-agent -s)"

pbcopy < ~/.ssh/id_rsa.pub
echo "SSH key copied to clipboard"
############################################


### AWS CLI ################################
echo "Installing AWS CLI..."
brew install awscli
############################################


### pyenv ##################################
echo "Installing pyenv..."
brew install pyenv
############################################


### terraform ##############################
echo "Installing terraform..."
brew install terraform
############################################


### terragrunt #############################
echo "Installing terragrunt..."
brew install terragrunt
############################################


### VSCode #################################
echo "Installing Visual Studio Code..."
brew install --cask visual-studio-code
############################################


### Postman ################################
echo "Installing Postman..."
brew install --cask postman
############################################


### PyCharm ################################
echo "Installing PyCharm..."
brew install --cask pycharm
############################################


### Docker #################################
echo "Installing Docker..."
brew install --cask docker
############################################


### Rectangle ##############################
echo "Installing Rectangle..."
brew install --cask rectangle
############################################


### Slack ##################################
echo "Installing Slack..."
brew install --cask slack
############################################


### Zoom ###################################
echo "Installing Zoom..."
brew install --cask zoom
############################################


# create symbolic links to shell config files
ln -sf ~/.shell_config/.zshrc ~/.zshrc
ln -sf ~/.shell_config/.bashrc ~/.bashrc
ln -sf ~/.shell_config/.zprofile ~/.zprofile
ln -sf ~/.shell_config/.bash_profile ~/.bash_profile
