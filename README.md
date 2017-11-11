# Evothings stack
This repository tries to collect our selected toolset for various projects we perform for our clients and internally. It's a Work-in-Process and does not try to capture all the tools we use, that would be very hard! But it does tries to pin point our preferred tools.

# Linux
We always use Linux for our servers. That typically boils down to Ubuntu LTS for cloud deployments, possibly Ubuntu Core for edge devices (if applicable), and for Raspberry we use Raspbian. And yeah, Debian is close at heart but we are no strangers to CentOS or other distributions either.

In the cloud we tend to prefer the more flexible modern hosting companies that use KVM, like for example our current favorite [Upcloud](http://upcloud.com) or Cloudsigma. We have worked a lot with Amazon too of course.

# Tools
We use the following tools for server building and management:

* [Packer](https://www.packer.io)
* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com/)
* [LXC/LXD](https://linuxcontainers.org/lxd/)
* [LXDock](https://lxdock.readthedocs.io/en/stable/index.html)
* [Ansible](https://www.ansible.com)

LXC/LXD is Linux only, but a very nice fast virtualization platform that both replaces Vagrant for development but can also be used as a deployment environment, much like Docker.

LXDock is just a Python wrapper around LXC/LXD in order to make it a bit more Vagrant-style , driven by a config file in a directory and so on. It does add a bit of convenience for provisioning, shell access, sharing folders, orchestrating several machines at once etc. You can use both `lxc` and `lxdock` commands to manage the machines.

# Software development
Our various languages and frameworks we use vary depending on project of course. We are polyglots but we also have preferences depending on context.

## Elixir and Phoenix
For serious 

## HTML5
On the frontend we have used Bootstrap/jQuery and MDL in earlier projects, and a range of other frameworks. For future projects we have decided to focus on Vuejs and use Quasar as the UI framework.

## Cordova
In Cordova mobile development we have used OnsenUI v2 in several projects. For future projects it's up in the air, there are so many options right now.

## Nodejs
For smaller services where it fits the requirements we often use Nodejs. It's not our preferred choice for more serious backends, but it works very well if the circumstances are right. Our own product Evothings Studio uses Nodejs on the server side, and Electron for the IDE.

## Nim
For smaller services targeting more constrained devices, or where the C/C++ eco system is important, we like the Nim programming language that offers fast development time together with very performant executables.

## Arduino
For IoT devices we tend to prefer the Arduino software eco system simply because it's so popular and thus has lots of reusable parts. It also has a very low rampup time, easy to get started and we can easily hand over results to our customers without them having to invest a lot of time in learning an RTOS or similar.

# Get going
The following are instructions for Ubuntu LTS, my preferred dev environment.
## LXD
See this [article series](http://insights.ubuntu.com/2016/03/14/the-lxd-2-0-story-prologue/) for all details on LXC/LXD, it's very nice. Details on how to install are found [here](https://linuxcontainers.org/lxd/getting-started-cli/) and if you are on Ubuntu, check out [my article](http://goran.krampe.se/2017/10/24/nim-crash-course-inside-lxc/) to get started ;)

## Packer
Just [download](https://www.packer.io/downloads.html) the single binary and put it in your path.

## LXDock
LXDock is mainly a "nicety" for juggling LXC for development, you can live without it. I haven't personally decided yet if it's really needed. :)

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
Ok, time to try it. Go into the `elixir` directory and use the `lxdock up` command. This should start and provision a Ubuntu LTS machine. It uses the configuration file called `lxdock.yaml` which in turn uses `provision.sh` to install everything.

    cd elixir
    lxdock up

The above should take about 3 minutes. It installs Elixir, PostgreSQL, PostGIS, hex and Phoenix. See the file `provision.sh` for the detailed steps.

Now the machine is running, check with `lxc list`. And we can get a shell in the machine, as the `ubuntu` user (this is configured in `lxdock.yaml`:

    lxdock shell

When inside the machine you can also check the log from the provisioning:

    sudo cat /root/provision.log

Note that the `elixir` directory is mounted inside the machine as `/host`.

# Using Packer
Packer uses a JSON file to build an LXC container and snapshot it as an image:

    packer build packer.json

This will produce a snapshotted LXC image called `elixir`. You can see it in the list of local images:

    lxc image list

And that means you can launch a new machine using this as a template:

    lxc launch local:elixir newmachine

And you can then log into it and look around:

    lxc exec newmachine -- su --login ubuntu
