#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ./install_helpers.sh

SYMLINK_PATH="${HOME}"

main() {
  mkdir -p "${HOME}/opt/bin"

  print_title "Specific dotfiles environment ?"
  if [[ -e "./dotfiles-env" ]]; then
    print_subtitle "Dotfiles-env file found : "
    cat ./dotfiles-env
    source "./dotfiles-env"
  else
    print_subtitle "No dotfiles-env file found"
  fi

  print_title "symlinks"
  for file in "${SCRIPT_DIR}/symlinks"/*; do
    basenameFile=$(basename "${file}")
    print_subtitle "Source $basenameFile..."

    [ -r "${file}" ] && [ -e "${file}" ] && ln -sf "${file}" "${SYMLINK_PATH}/.${basenameFile}"
  done

  set +u
  set +e
  PS1='$' source "${SYMLINK_PATH}/.bashrc"
  set -e
  set -u

  print_title "Installs"
  for file in "${SCRIPT_DIR}/install"/*; do
    local basenameFile=$(basename ${file%.*})
    print_subtitle "${basenameFile}"

    [ -r "${file}" ] && [ -x "${file}" ] && "${file}"
  done

  if [[ "$DOTFILES_ENV" != "" ]] && [[ -e "./install__$DOTFILES_ENV.sh" ]]; then
    print_subtitle "Custom install ./install__$DOTFILES_ENV.sh..."
    ./install__$DOTFILES_ENV.sh
  else
    print_subtitle "No dotfiles env"
  fi


  print_title "Cleanup"
  if [[ "${IS_MACOS}" == true ]]; then
    brew cleanup
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get autoremove -y
    sudo apt-get clean all
  fi

  print_subtitle "All done!"
}

main
