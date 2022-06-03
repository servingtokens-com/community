# from https://clubmate.fi/simple-static-site-deploy-script-built-with-bash

#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

readonly PROJECT_NAME='example'
readonly TARGET_PATH='/var/www/example.com/public_html'
readonly SOURCE_PATH='public/'
readonly SITE_URL='https://example.com'
readonly SERVER="${1:-}"

green() {
  echo "\\033[32m${1}\\033[m"
}

red() {
  echo "\\033[31m${1}\\033[m"
}

yellow() {
  echo "\\033[33m${1}\\033[m"
}

# Since we're doing some rm stuff, better check if this is the right Git project
# so it don't reek havoc if run in a wrong directory
die_if_wrong_project() {
  local CURRENT_PROJECT=$(basename "$(git rev-parse --show-toplevel)")

  if [ "$CURRENT_PROJECT" != "$PROJECT_NAME" ]; then
    red "\\n😱  wrong project, this script is configured to be used in a project named ${PROJECT_NAME}\\n"
    exit 1
  fi
}

die_if_dirty() {
  local CHANGED_FILES=$(git diff-index --name-only HEAD --)

  if [ "$CHANGED_FILES" != "" ]; then
    red "\\n😱  the repository is not clean:\\n ${CHANGED_FILES}\\n"
    exit 1
  fi
}

die_if_untracked_files() {
  local UNTRACKED=$(git ls-files --exclude-standard --others)

  if [ "$UNTRACKED" != "" ]; then
    red "\\n😱  there are untracked files:\\n ${UNTRACKED}\\n"
    exit 1
  fi
}

die_if_ahead_of_remote() {
  local UPSTREAM="@{u}"
  local LOCAL=$(git rev-parse @)
  local REMOTE=$(git rev-parse "$UPSTREAM")

  if [ "$LOCAL" != "$REMOTE" ]; then
    red "\\n😱  the local branch is not up to date with the remote, please do a git push\\n"
    exit 1
  fi
}

move_files_to_server() {
  yellow "File transfer started, might take a moment."
  rsync -az --info=progress2 --exclude=".*/" --chmod=+rwx --delete "${SOURCE_PATH}" "${SERVER}":"${TARGET_PATH}"
  green "Files moved to ${SERVER}:${TARGET_PATH}."
}

yellow "Started the deploy process, may take a moment..."
die_if_wrong_project
die_if_dirty
die_if_untracked_files
die_if_ahead_of_remote
npm run build
move_files_to_server
green "Deployd to: ${SITE_URL}. Have a nice day!"
