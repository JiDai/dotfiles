#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${IS_MACOS}" == true ]]; then
  brew install python pyenv pyenv-virtualenvwrapper
  brew cask install vagrant virtualbox tunnelblick

  vagrant plugin install vagrant-notify
  vagrant plugin install vagrant-vbguest
  vagrant plugin install vagrant-gatling-rsync
  vagrant plugin install vagrant-scp

  # required for zlib headers in Mojave
  sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

  echo "10.42.42.2 www.meilleursagents.vm static.meilleursagents.vm static0.meilleursagents.vm fry2.meilleursagents.vm mailapi.meilleursagents.vm partners.meilleursagents.vm
${MA_DEV_API_IP} api.meilleursagents.vm" | sudo tee -a /etc/hosts > /dev/null
fi
