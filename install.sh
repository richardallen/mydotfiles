#!/usr/bin/env bash
# Installs my dotfiles.

readonly PROG_NAME="$(basename $0)"
readonly PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly ARGS="$@"

readonly MYDOTFILES_REPO='https://github.com/richardallen/mydotfiles.git'
readonly MYDOTFILES="${HOME}/mydotfiles"
readonly MYDOTFILES_BACKUP="/tmp/mydotfiles_backup_$(date +"%s")"
readonly PRIVATE_DOTFILES="${HOME}/private_mydotfiles"
readonly PRIVATE_DOTFILES_BACKUP="/tmp/private_mydotfiles_backup_$(date +"%s")"
readonly LINKS_FILE="${HOME}/.mydotfiles_links"

private_dotfiles_repo='unknown'

usage() {
  cat <<EOF

Usage: ${PROG_NAME} --private=<url> [--debug] [--help]

  Installs my dotfiles.

Options:
  --private=URL     URL of your private dotfiles Git repository. Store secrets there.
  --debug           (optional) Enables bash debugging.
  --help            (optional) Prints this help message and exits.

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
            --private)
                private_dotfiles_repo="${value}"
                ;;
            --debug)
                set -x
                ;;
            --help)
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
    if [ ! -d $HOME ]; then
        log_error "There's a problem. Seems you're \$HOMEless :("
        exit 1;
    fi

    assert_tool_installed 'grep'
    assert_tool_installed 'git'
    assert_tool_installed 'curl'
}

get_sudo_pswd() {
    log 'Some changes require sudo privileges, so you need to enter your password.'
    sudo -v

    # Keep-alive: update existing sudo time stamp until the script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

do_backup_dotfiles() {
    local dir="$1"
    local bak="$2"

    if [ -d "${dir}" ]; then
        cd "${dir}"
        local nothing_to_commit="$(git status | grep 'nothing to commit' 2>&1)"
        local branch_is_ahead="$(git status | grep 'branch is ahead' 2>&1)"

        if [[ -z "${nothing_to_commit}" || -n "${branch_is_ahead}" ]]; then
            log_error "Your local clone at ${dir} has uncommitted changes. Push or revert these changes."
            exit 1;
        fi
    fi

    cd $HOME
    log "Backing up ${dir} to ${bak}"

    if [ -a "${bak}" ]; then
        log "Deleting existing directory ${bak}"
        rm -rf "${bak}"
    fi

    mv "${dir}" "${bak}"
}

backup_mydotfiles() {
    do_backup_dotfiles "${MYDOTFILES}" "${MYDOTFILES_BACKUP}"
    do_backup_dotfiles "${PRIVATE_DOTFILES}" "${PRIVATE_DOTFILES_BACKUP}"
}

unlink_dotfiles() {
    if [ -f "${LINKS_FILE}" ]; then
        for link in $(cat "${LINKS_FILE}"); do
            unlink "${link}"
        done

        rm -f "${LINKS_FILE}"
    else
        for dotfile in $(ls "${MYDOTFILES}/dotfiles"); do
            unlink "${HOME}/.${dotfile}"
        done

        for dotfile in $(ls "${PRIVATE_DOTFILES}/dotfiles"); do
            unlink "${HOME}/.${dotfile}"
        done
    fi
}

clone_mydotfiles() {
    cd $HOME

    log 'Cloning mydotfiles repository'
    git clone --recurse-submodules "${MYDOTFILES_REPO}"

    log 'Cloning private dotfiles repository'
    git clone "${private_dotfiles_repo}" "${PRIVATE_DOTFILES}"
}

link_dotfiles() {
    touch "${LINKS_FILE}"

    for dotfile in $(ls "${MYDOTFILES}/dotfiles"); do
        ln -s "${MYDOTFILES}/dotfiles/${dotfile}" "${HOME}/.${dotfile}"
        echo "${HOME}/.${dotfile}" >>"${LINKS_FILE}"
    done

    for dotfile in $(ls "${PRIVATE_DOTFILES}/dotfiles"); do
        ln -s "${PRIVATE_DOTFILES}/dotfiles/${dotfile}" "${HOME}/.${dotfile}"
        echo "${HOME}/.${dotfile}" >>"${LINKS_FILE}"
    done

    ln -s "${MYDOTFILES}/bin" "${HOME}/bin"
    echo "${HOME}/bin" >>"${LINKS_FILE}"
}

configure_node() {
    mkdir $HOME/.nvm
    source "${MYDOTFILES}/dotfiles/zsh/nvm.zsh"

    nvm install node
    nvm use node

    npm install -g 'yarn'
    npm install -g 'yo'
    npm install -g '@angular/cli'
    # npm install -g 'aws-appsync-codegen'
    # npm install -g 'graphql-cli'
}

configure_vim() {
    # Install vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    ln -s "${MYDOTFILES}/configs/vim" ~/.vim/settings

    log 'Installing vim plugins'
    vim +PlugInstall +qall >/dev/null 2>&1
}

# Invoke _after_ zplug is installed.
configure_zsh() {
    ${MYDOTFILES}/bin/zplug-setup.sh
}

# TODO: Use requirements.txt
#install_python_tools() {
    # Use Python 3 venv instead https://docs.python.org/3/library/venv.html
    #pip install virtualenv
#}

# TODO: Setup WebStorm
#configure_webstorm() {
#}

# TODO: Setup vscode
configure_vscode() {
    code --install-extension robertohuertasm.vscode-icons
    code --install-extension EditorConfig.EditorConfig
    code --install-extension msjsdiag.debugger-for-chrome

    code --install-extension vscjava.vscode-java-pack
    code --install-extension ms-python.python

    code --install-extension xabikos.JavaScriptSnippets
    code --install-extension vsmobile.vscode-react-native
    code --install-extension stringham.move-ts
    code --install-extension prisma.vscode-graphql
    code --install-extension johnpapa.Angular2
    code --install-extension Mikael.Angular-BeastCode
    code --install-extension Angular.ng-template
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension eg2.tslint

    code --install-extension sodatea.velocity

    code --install-extension donjayamanne.githistory
    code --install-extension christian-kohler.path-intellisense

    code --install-extension mauve.terraform

#    code --install-extension WakaTime.vscode-wakatime
#    code --install-extension alexdima.copy-relative-path
#    code --install-extension dbaeumer.vscode-eslint
#    code --install-extension formulahendry.auto-close-tag
#    code --install-extension formulahendry.auto-rename-tag
#    code --install-extension mjmcloug.vscode-elixir
#    code --install-extension ms-python.python
#    code --install-extension msjsdiag.debugger-for-chrome
#    code --install-extension octref.vetur
#    code --install-extension streetsidesoftware.code-spell-checker
#    code --install-extension teabyii.ayu
}

delete_backup() {
    log "Deleting backup at ${MYDOTFILES_BACKUP}"
    rm -rf "${MYDOTFILES_BACKUP}"

    log "Deleting backup at ${PRIVATE_DOTFILES_BACKUP}"
    rm -rf "${PRIVATE_DOTFILES_BACKUP}"
}

# TODO: Integrate mackup
main() {
    parse_args ${ARGS}

    set -Eeuo pipefail

    assert_env
    get_sudo_pswd
#    backup_mydotfiles
    unlink_dotfiles
#    clone_mydotfiles
    link_dotfiles

    if [[ "$(uname)" == 'Darwin' ]]; then
        "${MYDOTFILES}/setup_mac.sh"
    else
        log_error 'Installation currently only supported for macOS.'
        exit 0
    fi

    configure_node
    configure_vim
    configure_zsh
#    install_python_tools
#    configure_vscode

#    delete_backup

    return 0
}

main
