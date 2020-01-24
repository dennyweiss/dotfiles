#!/bin/bash

# add php to PATH
# see https://github.com/Homebrew/homebrew-core/issues/26107#issuecomment-378353791
#     https://gist.github.com/vukanac/e32c71d0d7c1444a1ac61469181ccaa6
#     https://gist.github.com/vukanac/e32c71d0d7c1444a1ac61469181ccaa6#gistcomment-2387716
PATH="$(brew --prefix php@7.2)/bin:$PATH"
PATH="$(brew --prefix php@7.2)/sbin:$PATH"
# add global composer library command line tools to PATH
PATH="$PATH:$HOME/.composer/bin"

export PATH

export COMPOSER_DISABLE_XDEBUG_WARN=1
