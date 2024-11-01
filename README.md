# SEC-TOOLS

Scripts to install some useful Security Assessment and Pentesting tools in Fedora Linux.
This isn't meant to replace full security distributions or Spins such as Kali Linux or the like. Simply to make installing some necessary tools onto Fedora Linux easier so I didn't have to keep doing it every time I built a new VM.

## Instructions

Clone the repo and run from Bash under the scripts/ directory.
Should be run as a regular user with sudo privileges. Ideally you should have NOPASSWD with sudo for a non-interactive installation.


### Ansible

Moving scripts to ansible. You'll need to have ansible installed.

```
$ python3 -m pip install ansible ansible-navigator
```

Edit the hosts file, whether you're running against your localhost or a VM. Then run setup.yml.

```
$ ansible-navigator run setup.yml -m stdout
```

You can also tag specific roles depending on your purpose. Eg. To install the reverse engineering role.

```
$ ansible-navigator run setup.yml -m stdout -treverse
```