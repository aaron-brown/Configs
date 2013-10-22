verswitch () { 
    if [[ -z $1 ]]
    then
        echo "Provide an update-alternatives identity."
        return 1
    fi

    sudo update-alternatives --config $1
}

vimpy () {
    if [[ $# != 1 ]]
    then
        builtin echo "A single filename must be provided."
        builtin echo
        return 1
    fi

    local file="$@.py"

    builtin echo "#! /usr/bin/python" > $file
    builtin echo >> $file
    vim $file
}

cdl () { builtin cd $1; ls; }
cdal () { builtin cd $1; ls -alh; }

pdl () { builtin pushd $1; ls; }
pdal () { builtin pushd $1; ls -alh; }

recgrep () {
    if [[ -z $1 ]]
    then
        echo "Please provide a search term [and directory path]."
        return 2
    fi

    if [[ -n $2 && ! -e "$2" ]]
    then
        echo "The path does not exist."
        return 3
    elif [[ -n $2 && ! -d "$2" ]]
    then
        echo "The path is not a directory."
        return 4
    elif [[ -n $2 ]]
    then
        local grepdir="$2"
    else
        local grepdir="."
    fi

    grep -R "$1" $grepdir
}

grmcache() {
    rm -rf ~/.grails/2.1.1/
    rm -rf ~/.ivy2
}

grun () { rm -rf $HOME/.grails/2.1.1/.slcache; grails run-app $@; }

grest () { grails test-app $@; }

grompile () { grails compile; }

grefreshdeps () { grails refresh-dependencies; }

grean () { grails clean; }

yupdate () { sudo yum update -y; }

# Create a Named Screen.
screenName () { screen -S $1; }

# Detach a Screen.
dscreen () { screen -d $1; }

# Recover a Named Screen.
rscreen () { screen -r $1; }

# List Screens.
lsscreen () { screen -ls; }
