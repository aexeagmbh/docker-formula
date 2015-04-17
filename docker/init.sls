docker-pkg-deps:
  pkg.installed:
    - pkgs:
      - linux-image-extra-virtual
      - python-apt
    - require_in:
      - pkg: lxc-docker

reboot-after-kernel-update:
  module.wait:
    - name: system.reboot
    - watch:
      - pkg: docker-pkg-deps

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
  pkg.installed:
    - require_in:
      - service: docker

docker:
  service.running
