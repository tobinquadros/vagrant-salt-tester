# /srv/salt/top.sls
base:
  '*':
    - openssh
    - openssh.config
    - openssh.banner
