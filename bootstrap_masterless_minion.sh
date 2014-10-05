#!/usr/bin/env bash

echo "Provisioning masterless minion..."

# Tag with UTC timestamp.
touch "salted-$(date -u +%Y-%m-%d-%R)"

# Official SaltStack bootstrap.sh.
wget -O - https://bootstrap.saltstack.com | sudo sh

# Bootstrap this minion. The --local option overrides the default master
# location set in /etc/salt/minion, which is master: salt. It also means you
# don't have to go into /etc/salt/minion and set file_client: local.
salt-call --local state.highstate -l debug

echo "That's the end of that! Whew."
