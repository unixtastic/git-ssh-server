git-ssh-server
=================

A minimal GIT server.

Build instructions:
===================

git clone https://github.com/unixtastic/git-ssh-server

docker build -t 'unixtastic/git-ssh-server' .

Usage instructions:
===================

To run this first create a data directory on your docker host to hold git data, ssh authentication,
and possibly git-shell-commands.

mkdir /docker_data/git

Run the container.

docker run -d -p 2222:22 -v /docker_data/git:/git unixtastic/git-ssh-server

You may substitute '2222' with any port number of your choosing.

To add users:

Setup SSH:
cd /docker_data/git && mkdir .ssh && chown -R 987 .ssh && chmod -R 700 .ssh && touch .ssh/authorized_keys

Add user public keys to .ssh/authorized_keys just like you would do for 'normal' SSH.

touch /docker_data/git/.hushlogin to prevent login banners that can confuse git.

To setup repos:

mkdir /docker_data/git/mynewproject.git
cd /docker_data/git/mynewproject.git
git --bare init
chown -R 987:987 .

Clone the repo from a client:
git clone ssh://git@myserver:2222/git/mynewproject.git

To setup git-shell-commands:

mkdir /docker_data/git/git-shell-commands
chown 987:987 /docker_data/git/git-shell-commands
chmod 700 /docker_data/git/git-shell-commands
Add your commands to the above directory. You might want to start with list, which
you can find under /usr/share/doc on most git client machines.

Notes:
======

The SSH host keys are generated at the first run of each new container. This will confuse some git clients and really should be changed.

