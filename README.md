# Evothings web stack
Our base platform is Ubuntu LTS. We use Packer, [LXC/LXD](https://linuxcontainers.org/lxd/) and [LXDock](https://lxdock.readthedocs.io/en/stable/index.html) to virtualize dev environments and produce appliances etc.

LXC/LXD is Linux only, but a very nice fast virtualization platform.

LXDock is just a Python wrapper around LXC/LXD in order to make it a bit more Vagrant-style , driven by a config file in a directory and so on. It does add a bit of convenience for provisioning, shell access, sharing folders, orchestrating several machines at once etc. You can use both `lxc` and `lxdock` commands to manage the machines.

# Tools
Install LXD, Packer and LXDock.

## LXD
....

## Packer
Just [download](https://www.packer.io/downloads.html) the single binary and put it in your path.

## LXDock
LXdock is installed using pip and it turned out to be a PITA to get pip3 working, I ended up doing this dance in my Ubuntu:

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
Ok, time to try it. Go into the `elixir` directory and use the `lxdock up` command. This should start and provision a Ubuntu LTS machine. It uses the configuration file called `lxdock.yaml`.

    cd elixir
    lxdock up

The above should take about 3 minutes. It installs Elixir, PostgreSQL, PostGIS, hex and Phoenix. See the file `provision.sh` for steps.

Then we can get a shell in the machine, as the `ubuntu` user:

    lxdock shell

You can also check the log from the provisioning:

    sudo cat /root/provision.log

Note that this directory is available inside the machine as `/host`.

# Using Packer
Packer uses a JSON file to build an LXC container and snapshot it as an image:

    packer build packer.json

This will produce a snapshotted LXC image called `elixir`. You can see it in the list of local images:

    lxc image list

And that means you can launch a new machine using this as a template:

    lxc launch local:elixir newmachine

And you can then log into it and look around:

    lxc exec newmachine -- su --login ubuntu
