# Evothings web stack
Our base platform is Ubuntu LTS. We use Packer, LXC/LXD and LXDock to virtualize dev environments and produce appliances etc.

LXC/LXD is Linux only, but a very nice fast virtualization platform.

LXDock is just a Python wrapper around LXC/LXD in order to make it a bit more Vagrant-style , driven by a config file in a directory and so on. It does add a bit of convenience for provisioning, shell access, sharing folders, orchestrating several machines at once etc. You can use both `lxc` and `lxdock` commands to manage the machines.

# Tools
Install LXD, Packer and LXDock.

## LXD
....

## Packer
....

## LXDock
It turned out to be a PITA to get pip3 working, I ended up doing this dance in my Ubuntu:

    sudo su                               # become root
    cd                                    # prevent trashing your user's python cache permissions
    apt-get install python3-pip           # bring in easy_install3
    pip install --upgrade pip             # cache latest pip sources
    apt-get remove python3-pip python-pip # remove Ubuntu's pip
    easy_install3 pip                     # install up to date vanilla pip
    pip --version                         # verify it
    exit                                  # back to your user.

Then I could finally:

    sudo pip3 install lxdock

And to get completion in bash:

    sudo curl -L https://raw.githubusercontent.com/lxdock/lxdock/$(lxdock --version | cut -d ' ' -f 2)/contrib/completion/zsh/_lxdock -o /usr/share/zsh/vendor-completions/_lxdock


# Using LXDock
Ok, time to try it. Go into the `elixir` directory and use the `lxdock up` command. This should start and provision a Ubuntu LTS machine.

    cd elixir
    lxdock up

The above should take about 3 min with a reasonable line. It installs Elixir, PostgreSQL, PostGIS, hex and Phoenix. See the file `provision.sh` for steps.

Then we can get a shell in the machine, as the `ubuntu` user:

    lxdock shell

Note that this directory is available inside the machine as `/host`.


