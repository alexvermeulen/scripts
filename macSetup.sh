#!/usr/bin/env bash

# Colour Constants
HEADING="\033[1;36m" # Cyan
INFO="\033[0;32m" # Green
WARNING="\033[0;33m" # Yellow
ERROR="\033[1;31m" # Bright red
RESET="\033[0m" # No colour

BREWFILE="${1:-"$HOME/.Brewfile"}"

echo_colour() {
    local string=$1
    local colour=${2:-$INFO}
    echo -e "${colour}${string}${RESET}"
}

install_prerequisites() {
    echo_colour "Installing and updating prerequesites." "$HEADING"

    # Check if command line tools are installed
    which -s gcc
    if [[ $? != 0 ]]; then
        # Install command line tools
        echo_colour "Installing command line tools."
        xcode-select --install
    else
        echo_colour "All prerequesites satisfied."
    fi
}

install_brews() {
    if [[ -f $BREWFILE ]]; then
        echo_colour "Installing Homebrew applications & packages." "$HEADING"
    else
        echo_colour "No Brewfile found." "$WARNING"
        echo_colour "To create one with your existing brews run 'brew bundle dump'." "$WARNING"
        return
    fi

    # Check if Homebrew is installed
    which -s brew
    if [[ $? != 0 ]]; then
        # Install Homebrew
        echo_colour "Installing Homebrew."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        # Update Homebrew
        echo_colour "Updating Homebrew."
        brew update
    fi

    # Check if Homebrew bundle is tapped
    if ! brew tap | grep "homebrew/bundle"; then
        echo_colour "Tapping Homebrew/bundle."
        brew tap Homebrew/bundle
    fi

    # Install brew applications
    brew bundle check --file="$BREWFILE"
    if [[ $? != 0 ]]; then
        echo_colour "Installing/updating Homebrew packages from $BREWFILE."
        brew bundle --file="$BREWFILE"
    else
        echo_colour "All brews are up-to-date."
    fi
}

install_prerequisites
install_brews
