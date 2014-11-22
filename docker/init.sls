docker-python-apt:
  pkg.installed:
    - name: python-apt

docker-py:
  pip.installed

docker_repo:
    pkgrepo.managed:
      - repo: 'deb http://get.docker.io/ubuntu docker main'
      - file: '/etc/apt/sources.list.d/docker.list'
      - key_url: salt://docker/docker.pgp
      - require_in:
          - pkg: lxc-docker

lxc-docker:
  pkg.latest:
    - require_in:
      - service: docker

docker:
  service.running
