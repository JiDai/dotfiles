#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  if [[ "${IS_MACOS}" == true ]]; then
    if ! command -v brew > /dev/null 2>&1; then
      mkdir "${HOME}/homebrew" && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "${HOME}/homebrew"
      # After install source path of homebrew for current run
      source "${SCRIPT_DIR}/../sources/_homebrew"
    fi

    brew update
    brew upgrade
    brew install \
      bash \
      bash-completion \
      htop \
      curl \
      ncdu \
      git \
      fswatch \
      openssl \
      tree \
      hub \
      httpie \
      mosh
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get upgrade -y -qq
    sudo apt-get install -y -qq apt-transport-https

    sudo apt-get install -y -qq \
      bash \
      bash-completion \
      git
  fi
}

main
