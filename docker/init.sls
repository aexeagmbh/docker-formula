docker-pkg-deps:
  pkg.installed:
    - pkgs:
      - linux-image-extra-virtual
      - python-apt
    - require_in:
      - pkg: lxc-docker

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
