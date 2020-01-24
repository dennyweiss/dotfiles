# Lines configured by zsh-newuser-install

SHOW_STARTUP_DURATION='true'

if [[ "${SHOW_STARTUP_DURATION}" == 'true' ]]; then
  start="$(date +%s)"
fi

HISTFILE=~/.history-file
HISTSIZE=10000
SAVEHIST=1000
setopt appendhistory autocd beep nomatch
unsetopt extendedglob notify
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle :compinstall filename '/Users/dschulz/.zshrc'
autoload -Uz compinit
compinit

# End of lines added by compinstall

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PYTHONUSERBASE="/Users/dschulz/.local"
PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:/usr/local/bin/git:${HOME}/.composer/vendor/bin:${PATH}"
PATH="${HOME}/bin:${PYTHONUSERBASE}/bin:${PATH}"
PATH="/usr/local/opt/icu4c/bin:${PATH}"
PATH="/usr/local/opt/icu4c/sbin:${PATH}"

if [ -d "${HOME}/.cargo/bin" ]; then
  PATH="${HOME}/.cargo/bin:${PATH}"
fi

if [ -d "/usr/local/opt/terraform@0.11/bin" ];then
  PATH="/usr/local/opt/terraform@0.11/bin:${PATH}"
fi

export PATH

# Setup antigen
source $(brew --prefix)/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Customize SPACESHIP theme
SPACESHIP_BATTERY_SHOW=false
SPACESHIP_DIR_TRUNC=5
SPACESHIP_CHAR_SYMBOL="⇲"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_DIR_TRUNC_PREFIX="…/"
SPACESHIP_PROMPT_ADD_NEWLINE=true 	# Adds a newline character before each prompt line 

spaceship_newline_indent() {
  spaceship::section 'white' '  '
}

SPACESHIP_PROMPT_ORDER=(
  char
  time
  user
  host
  dir
  git
  package
  node
  ruby
  golang
  php
  rust
  docker
  venv
  conda
  pyenv
  dotnet
  exec_time
  line_sep
  vi_mode
  jobs
  exit_code
  newline_indent
)

# Load the theme.
antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle greymd/docker-zsh-completion

# Tell Antigen that you're done.

antigen apply

DOTFILES_EXTENSIONS="${HOME}/.dotfiles/src"
ADD_EXTENSIONS="true"
if [[ -d "${DOTFILES_EXTENSIONS}" && "${ADD_EXTENSIONS}" == 'true' ]]; then
  for extension in ${DOTFILES_EXTENSIONS}/*.zsh; do
    source "${extension}"
  done
else
  echo ""
  echo -e "Could not source files in ${DOTFILES_EXTENSIONS}"
  echo ""
fi

export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [[ "${SHOW_STARTUP_DURATION}" == 'true' ]]; then
  end=`date +%s`
  runtime=$((end-start))
  echo -e "==> Shell Start Duration: ${runtime}"
fi
