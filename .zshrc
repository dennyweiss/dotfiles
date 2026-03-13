# Lines configured by zsh-newuser-install

SHOW_STARTUP_DURATION='true'

if [[ "${SHOW_STARTUP_DURATION}" == 'true' ]]; then
  start="$(date +%s)"
fi

if [[ ! -f "${HOME}/.history-file" ]]; then
  touch "${HOME}/.history-file"
fi

HISTFILE="${HOME}/.history-file"
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# setopt hist_ignore_all_dups # ignore duplicate history entries
setopt appendhistory autocd beep nomatch
unsetopt extendedglob notify
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
fpath+=(${HOME}/.config/hcloud/completion/zsh)
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
if dscl . -read /Groups/admin GroupMembership 2>/dev/null | grep -qw "$(whoami)"; then
  compinit
else
  compinit -u
fi

# End of lines added by compinstall

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PYTHONUSERBASE="${HOME}/.local"
PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${PATH}"
PATH="${HOME}/bin:${PYTHONUSERBASE}/bin:${PATH}"
PATH="/usr/local/opt/icu4c/bin:${PATH}"
PATH="/usr/local/opt/icu4c/sbin:${PATH}"

if [ -d "${HOME}/.cargo/bin" ]; then
  PATH="${HOME}/.cargo/bin:${PATH}"
fi

if [ -d /usr/local/opt/ncurses/bin ]; then
  PATH="/usr/local/opt/ncurses/bin:$PATH"
fi

if [[ -d /opt/homebrew/opt/mysql-client/bin ]]; then
  PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
fi

export PATH

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if which brew &>/dev/null; then
  _BREW_PYTHON_PATH="$(brew --prefix)/bin/python3"
  if [[ -f "${BREW_PYTHON_PATH}" ]];then
    VIRTUALENVWRAPPER_PYTHON="${_BREW_PYTHON_PATH}"
  fi

  # Setup antigen
  source $(brew --prefix)/share/antigen/antigen.zsh
fi

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Customize SPACESHIP theme
SPACESHIP_BATTERY_SHOW=false
SPACESHIP_DIR_SHOW=true
SPACESHIP_DIR_TRUNC=5
SPACESHIP_DIR_PREFIX=''
SPACESHIP_DIR_TRUNC_PREFIX="…/"
SPACESHIP_CHAR_SYMBOL="⇲"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_PROMPT_ADD_NEWLINE=false 	# Adds a newline character before each prompt line

spaceship_newline_indent() {
  spaceship::section ''
}

if ! docker ps &>/dev/null; then
  # spaceship_docker when Docker daemon is not
  export SPACESHIP_DOCKER_SHOW=false
fi

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
  dotnet
  exec_time
  line_sep
  jobs
  exit_code
  newline_indent
)

# Load the theme.
antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

# Bundles from the default repo (robbyrussell's oh-my-zsh).
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

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if which direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

if which zed &>/dev/null; then
  export GIT_EDITOR="zed --wait"
  export EDITOR="zed --wait"
  export VISUAL="${EDITOR}"
else
  export EDITOR="$(which nano)"
  export VISUAL="${EDITOR}"
fi

if which ssh-agent-activate &>/dev/null; then
  ssh-agent-activate --silent
fi

if [[ "${SHOW_STARTUP_DURATION}" == 'true' ]]; then
  end=$(date +%s)
  runtime=$((end-start))
  echo -e "==> Shell Start Duration: ${runtime}"
fi

if [[ -f .nvmrc ]] && which nvm &>/dev/null; then
  nvm use
fi

export HOMEBREW_GITHUB_API_TOKEN=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
export HOMEBREW_NO_AUTO_UPDATE=1
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [[ -f "${HOME}/.local/share/google-cloud-sdk/path.zsh.inc" ]]; then . "${HOME}/.local/share/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [[ -f "${HOME}/.local/share/google-cloud-sdk/completion.zsh.inc" ]]; then . "${HOME}/.local/share/google-cloud-sdk/completion.zsh.inc"; fi

if docker context inspect &>/dev/null; then
  # required to be able to use `dive` for docker image inspection with `colima`
  export DOCKER_HOST=$(docker context inspect --format='{{.Endpoints.docker.Host}}')
fi

# Herd injected PHP binary.
export PATH="${HOME}/Library/Application Support/Herd/bin/":$PATH
# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="${HOME}/Library/Application Support/Herd/config/php/85/"
# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="${HOME}/Library/Application Support/Herd/config/php/84/"
# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="${HOME}/Library/Application Support/Herd/config/php/83/"

# pnpm
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

export CC_PROMPT_DB_CONNECTION=${HOME}/.claude/cc-prompt.sqlite
[[ -f ${HOME}/Code/claude-code-tooling/cc-prompt ]] && export PATH=${HOME}/Code/claude-code-tooling:$PATH

export CC_TELEGRAM_WEBHOOK_URL="https://do-01.whaaat.ai/webhook/cb182be6-e732-492d-b8a6-2a09a5046000"
export CC_TELEGRAM_API_KEY="3ded09bb-4d2b-43dc-893b-b5d231ebc0c3"
export CC_TELEGRAM_CHAT_ID="5096201627"

# bun
export BUN_INSTALL="${HOME}/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Claude Code
export DISABLE_INSTALLATION_CHECKS=1
