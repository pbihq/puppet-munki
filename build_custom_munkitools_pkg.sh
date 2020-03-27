#!/bin/bash

# Build custom Munki package that includes all necessary dependencies for
# CloudFront-Middleware
# See: https://github.com/AaronBurchfield/CloudFront-Middleware#munki-4-and-python-3

# ##############################################################################
# Set global properties
readonly munkiRepoUrl="https://github.com/munki/munki.git"

# ##############################################################################
# Set path
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# ##############################################################################
# LOGGING WITH COLOR FOR CLI SCRIPT
# ##############################################################################
# Set up logging
info()     { printf "[INFO] %s" "$*" 1> >(sed $'s,.*,\e[32m&\e[m,'); sleep 0.01; }
warning()  { printf "[WARNING] %s" "$*" 1> >(sed $'s,.*,\e[33m&\e[m,'); }
error()    { printf "[ERROR] %s" "$*" 1> >(sed $'s,.*,\e[35m&\e[m,'); }
critical() { printf "[CRITICAL] %s\n" "$*" 1> >(sed $'s,.*,\e[31m&\e[m,'); sleep 0.01; exit 1; }

# ##############################################################################
# Set unofficial Bash strict mode
# Source: https://dev.to/thiht/shell-scripts-matter
set -euo pipefail
IFS=$'\n\t'

readonly workDir="$(pwd)"

# ##############################################################################


# Check if operating system is macOS
checkOS() {
    if [[ ! "$(uname)" = "Darwin" ]]; then return 1; fi
}

# Make sure this script is not being executed run as root
checkRoot() {
    if [ "$EUID" -eq 0 ]; then return 1; fi
}

# Check if program is installed
checkInstalled() {
    command -v "$1" > /dev/null
}

createTempDir() {
  readonly tmpDir=$(mktemp -d)
}

# Clean up step in case of errors and at the end
cleanUp() {
  info "Cleaning up …"
  rm -rf "${tmpDir:?error}"
}

cloneMunki() {
  info "Cloning Munki repo ..."
  git clone "$munkiRepoUrl" "$tmpDir"
}

editDependencies() {
  printf "\nrsa" >> "$tmpDir/code/tools/py3_requirements.txt"
}

buildPython() {
  info "Downloading and building custom Python framework ..."
  cd "$tmpDir"
  ./code/tools/build_python_framework.sh
}

buildMunki() {
  info "Building Munki pkg ..."
  cd "$tmpDir"
  ./code/tools/make_munki_mpkg.sh
  mv ./munkitools*.pkg "$workDir"/files/
}

checkOS || critical "It seems you are not running macOS. Exiting..."

checkRoot || critical "Please run this script with elevated privileges"

checkInstalled mktemp || critical "mktemp not found. Please install!"

checkInstalled git || critical "Git not found. Please install!"

# Script startup checks
trap cleanUp SIGINT TERM EXIT

createTempDir

cloneMunki || critical "Could not clone Munki repo"

editDependencies || critical "Could not edit dependencies"

buildPython || critical "Could not build custom Python framework"

buildMunki || critical "An error occured during Munki build phase"

exit 0
