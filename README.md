# SEC-TOOLS

Scripts to install some useful Security Assessment and Pentesting tools in Fedora Linux.
This isn't meant to replace full security distributions or Spins such as Kali Linux or the like. Simply to make installing some necessary tools onto Fedora Linux easier so I didn't have to keep doing it every time I built a new VM.

## Instructions

Clone the repo and run from Bash under the scripts/ directory.
Should be run as a regular user with sudo privileges. Ideally you should have NOPASSWD with sudo for a non-interactive installation.


### Ansible

Moving scripts to ansible. You'll need to have ansible installed.

```
$ python3 -m pip install ansible
```

Edit the inventory file if you're running against remote virtual machines.
You'll also need to install the additional ansible collections.

```
$ ansible-galaxy collection install -r requirements.yml
```

Now you can run the setup.


```
$ ansible-playbook setup.yml
```

You can also tag specific roles depending on your purpose. Eg. To install the reverse engineering role.

```
$ ansible-playbook setup.yml -treverse
```