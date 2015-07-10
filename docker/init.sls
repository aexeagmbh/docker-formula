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

docker-py==1.2.3:
  pip.installed:
    - upgrade: True

docker-repo:
    pkgrepo.managed:
      - repo: 'deb http://get.docker.io/ubuntu docker main'
      - file: '/etc/apt/sources.list.d/docker.list'
      - key_url: salt://docker/docker.pgp

{% if salt['pillar.get']('docker-version') %}
lxc-docker-uninstalled:
  pkg.removed:
    - watch_in:
      - service: docker
    - require:
      - pkgrepo: docker-repo

lxc-docker:
  pkg.installed:
    - name: lxc-docker-{{ pillar['docker-version'] }}
    - watch_in:
      - service: docker
    - require:
      - pkgrepo: docker-repo
      - pkg: lxc-docker-uninstalled
{% else %}
lxc-docker:
  pkg.installed:
    - watch_in:
      - service: docker
    - require:
      - pkgrepo: docker-repo
{% endif %}

docker:
  service.running
