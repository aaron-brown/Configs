#/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

verbose=false

print_help () {
    echo "Usage: make_myself_at_home.sh [-v|--verbose] <--all|[specifics]>>"
    echo ""
    echo "Example (all):"
    echo "  make_myself_at_home.sh --all"
    echo ""
    echo "Example (specific):"
    echo "  make_myself_at_home.sh --bash --git"
}

v_out () {
    if [[ -z $1 ]]; then
        echo "No verbouse output."
        return 1
    fi

    if [[ ${verbose} == true ]]; then
        echo $1
    fi
}

setup_bash () {
    if [[ -e ${HOME}/.bashrc ]]
    then
        if [[ -e ${HOME}/.bashrc.bk ]]
        then
            local backup_extension="-$(uuidgen).bk"
        else
            local backup_extension=".bk"
        fi

        v_out "Backing up ${HOME}/.bashrc to: ${HOME}/.bashrc${backup_extension}"

        mv ${HOME}/.bashrc ${HOME}/.bashrc${backup_extension}
        
        v_out "Setting up .bashrc symlink"
        ln -s ${DIR}/.bash/.bashrc ${HOME}/.bashrc

        v_out "Sourcing ${HOME}/.bashrc"
        source ${HOME}/.bashrc
        
        v_out "Bash setup complete."
    fi
}

setup_git () {
    if [[ -e ${HOME}/.gitconfig ]]
    then
        if [[ -e ${HOME}/.gitconfig.bk ]]
        then
            local backup_extension="-$(uuidgen).bk"
        else
            local backup_extension=".bk"
        fi

        v_out "Backing up ${HOME}/.gitconfig to: ${HOME}/.gitconfig${backup_extension}"

        mv ${HOME}/.gitconfig ${HOME}/.gitconfig${backup_extension}
        
        v_out "Copying .gitconfig"
        cp ${DIR}/._git/.gitconfig ${HOME}/.gitconfig

        v_out "Git setup complete."
        v_out "Remember to set up your username and password!"
    fi
}

setup_vim () {
    if [[ -e ${HOME}/.vimrc ]]
    then
        if [[ -e ${HOME}/.vimrc.bk ]]
        then
            local backup_extension="-$(uuidgen).bk"
        else
            local backup_extension=".bk"
        fi

        v_out "Backing up ${HOME}/.vimrc to: ${HOME}/.vimrc${backup_extension}"

        mv ${HOME}/.vimrc ${HOME}/.vimrc${backup_extension}

        if [[ -e ${HOME}/.vim ]]
        then
            v_out "Backing up ${HOME}/.vim to: ${HOME}/.vim${backup_extension}"
            mv ${HOME}/.vim ${HOME}/.vim${backup_extension}
        fi
        
        v_out "Setting up .vimrc symlink"
        ln -s ${DIR}/.vim/.vimrc ${HOME}/.vimrc

        v_out "Setting up .vim symlink"
        ln -s ${DIR}/.vim ${HOME}/.vim

        v_out "VIM setup complete."
    fi
}

OPTS=$(getopt -o vh -l all,bash,git,vim,"help",verbose -- "$@")

if [ -z $? ]; then
    echo "Failed to parse opts."
    exit 1
fi

eval set -- "${OPTS}"

while true ; do
    case "$1" in
        -h | --help) print_help; break;;
        -v | --verbose) verbose=true; shift;;
        --git) setup_git; shift;;
        --vim) setup_vim; shift;;
        --bash) setup_bash; shift;;
        --all) 
            setup_git; 
            setup_vim; 
            setup_bash; 
            break;;
        --) shift; break;;
    esac
done
