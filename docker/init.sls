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

docker-repo:
    pkgrepo.managed:
      - repo: 'deb http://get.docker.io/ubuntu docker main'
      - file: '/etc/apt/sources.list.d/docker.list'
      - key_url: salt://docker/docker.pgp

{% if salt['pillar.get']('docker-version') %}
lxc-docker:
  pkg.removed:
    - watch_in:
      - service: docker
    - require:
      - pkgrepo: docker-repo

lxc-docker-{{ pillar['docker-version'] }}:
  pkg.installed:
    - watch_in:
      - service: docker
    - require:
      - pkgrepo: docker-repo
      - pkg: lxc-docker
{% else %}
lxc-docker-{{ pillar['docker-version'] }}:
  pkg.installed:
    - watch_in:
      - service: docker
    - require:
      - pkgrepo: docker-repo
{% endif %}

docker:
  service.running
