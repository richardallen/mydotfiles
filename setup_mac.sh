#!/usr/bin/env bash
# Sets up my mac.

readonly PROG_NAME="$(basename $0)"
readonly PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly ARGS="$@"

readonly MYDOTFILES="${PROG_DIR}"

usage() {
  cat <<EOF

Usage: ${PROG_NAME} [--debug] [--help]

  Sets up my mac.

Options:
  -d --debug    (optional) Enables bash debugging.
  -h --help     (optional) Prints this help message and exits.

EOF
}

parse_args() {
    local param=''
    local value=''

    while [ "$1" != '' ]
    do
        param="$(awk -F= '{print $1}' <<<"$1")"
        value="$(awk -F= '{print $2}' <<<"$1")"

        case "${param}" in
            -d | --debug)
                set -x
                ;;
            -h | --help)
                usage
                exit 0
                ;;
            *)
                log_error "Invalid option '${param}'"
                usage
                exit 1
                ;;
        esac
        shift
    done

    return 0
}

log() {
    printf '\n%s\n' "$1"
}

log_error() {
    printf '\nERROR: %s\n\n' "$1" >&2
}

assert_tool_installed() {
    local tool="$1"

    if command -v "${tool}" >/dev/null 2>&1 ; then
        return 0
    else
        log_error "'${tool}' must be installed on this computer and present on the PATH."
        exit 1
    fi
}

assert_env() {
    if [ ! -d "${HOME}" ]; then
        log_error "There's a problem. Seems you're \$HOMEless :("
        exit 1;
    fi

    assert_tool_installed 'grep'
    assert_tool_installed 'git'
    assert_tool_installed 'curl'
}

install_hosts_file() {
    log 'Installing hosts file from https://someonewhocares.org/hosts/hosts, with backup at /private/etc/hosts.backup'

    sudo cp /private/etc/hosts /private/etc/hosts.backup
    sudo curl -fLo /private/etc/hosts https://someonewhocares.org/hosts/hosts
}

install_homebrew() {
    if ! command -v 'brew' >/dev/null 2>&1 ; then
        log 'Installing Homebrew'
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    log 'Updating Homebrew'
    brew update
    brew upgrade
}

install_brewbundle() {
    log 'Installing tools via Homebrew bundle'
    brew bundle # Installs libraries defined in Brewfile
    brew cleanup >/dev/null 2>&1

    log 'Installing fzf key bindings and fuzzy completion'
    $(brew --prefix)/opt/fzf/install --all --no-fish
}

set_zsh() {
    log 'Setting login shell to zsh'

    if ! grep '/usr/local/bin/zsh' /etc/shells >/dev/null 2>&1 ; then
        echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells >/dev/null
    fi

    sudo chsh -s /usr/local/bin/zsh $USER
    #sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh >/dev/null 2>&1
}

configure_iterm() {
    local iterm_dir="$HOME/.iterm/themes"
    local iterm_repo="https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes"

    log 'Downloading Solarized files'
    mkdir -p "${iterm_dir}"

    # Download Solarized Dark theme for Terminal.app from Mathias Bynens dotfiles
    curl -fLo "${iterm_dir}/SolarizedDarkXterm256.terminal" \
        https://raw.githubusercontent.com/mathiasbynens/dotfiles/master/init/Solarized%20Dark%20xterm-256color.terminal

    # Download Solarized iTerm2 color themes.
    curl -fLo "${iterm_dir}/SolarizedDarcula.itermcolors" \
        "${iterm_repo}/Solarized%20Darcula.itermcolors"

    curl -fLo "${iterm_dir}/SolarizedDarkPatched.itermcolors" \
        "${iterm_repo}/Solarized%20Dark%20-%20Patched.itermcolors"

    curl -fLo "${iterm_dir}/SolarizedDarkHigherContrast.itermcolors" \
        "${iterm_repo}/Solarized%20Dark%20Higher%20Contrast.itermcolors"

    curl -fLo "${iterm_dir}/SolarizedDark.itermcolors" \
        "${iterm_repo}/Solarized%20Dark.itermcolors"

    curl -fLo "${iterm_dir}/SolarizedLight.itermcolors" \
        "${iterm_repo}/Solarized%20Light.itermcolors"

    # TODO: How to make this repeatable?
    for theme_file in "${iterm_dir}"/*.itermcolors ; do
        open "${theme_file}"
    done

    # Specify the iTerm2 preferences directory
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${MYDOTFILES}/configs/iterm2"

    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

    # Download Solarized dircolors
    curl -fLo "${iterm_dir}/dircolors.256dark" \
        https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
}

main() {
    parse_args ${ARGS}

    set -Eeuo pipefail

    log 'Configuring your mac'

    assert_env
    install_hosts_file
    install_homebrew
    install_brewbundle
    set_zsh
    configure_iterm

    log 'Configuring macOS settings'
    "${PROG_DIR}/macos.sh"

    return 0
}

main
