#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ./install_helpers.sh

# Check env variables
env_vars=( MA_FOLDER MA_REPOSITORY MA_DEV_API_IP )
for env_var in ${env_vars[@]}; do
  if [[ -z "${!env_var-}" ]]; then
  	print_error "Please specify $env_var in env"
	  exit 1
  fi
done

if [[ "${IS_MACOS}" == true ]]; then
  sudo /usr/bin/easy_install virtualenv
  brew install python pyenv pyenv-virtualenv
  brew cask install vagrant tunnelblick
  # Must enable Oracle in System Preferences / Security for installing virtualbox
  brew cask install virtualbox

  vagrant plugin install vagrant-notify
  vagrant plugin install vagrant-vbguest
  vagrant plugin install vagrant-gatling-rsync
  vagrant plugin install vagrant-scp

  # required for zlib headers in Mojave
  sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

  echo "10.42.42.2 www.meilleursagents.vm static.meilleursagents.vm static0.meilleursagents.vm fry2.meilleursagents.vm mailapi.meilleursagents.vm partners.meilleursagents.vm
  ${MA_DEV_API_IP} api.meilleursagents.vm" | sudo tee -a /etc/hosts > /dev/null
fi
