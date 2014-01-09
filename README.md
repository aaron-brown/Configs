# Configs

This is basically my master resource for my home environment.

Its purpose is so I can quickly get my environment set up since with VMs and
just general installs I want to have everything be as "the same" as possible.

I've even included an automated script for setting up the environment.

`./make_myself_at_home.sh --all`

The typical usage would be the following:

    cd    # $HOME
    git clone git@github.com:aaron-brown/Configs.git
    ./Configs/make_myself_at_home.sh --all
    # Setup git-configs here.

The `./make_myself_at_home.sh` script sets symlinks up within the Configs
directory, so then updates can be distributed via pulling and resourcing.
