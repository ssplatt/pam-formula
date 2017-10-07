# vim: ft=sls
# How to configure pam
{%- from "pam/map.jinja" import pam with context %}

pam_google2fa_authenticator:
  pkg.installed:
    - name: {{ pam.google2fa.pkg }}

pam_google2fa_skel_config:
  file.managed:
    - name: /etc/skel/.google_authenticator
    - user: root
    - group: root
    - mode: 0644

{% if pam.google2fa.ssh %}
pam_google2fa_ssh_config:
  file.managed:
    - name: /etc/pam.d/sshd
    - source: salt://pam/files/pam_sshd.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
{% endif %}

{% if pam.google2fa.sudo %}
pam_google2fa_sudo_config:
  file.managed:
    - name: /etc/pam.d/sudo
    - source: salt://pam/files/pam_sudo.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
{% endif %}

{% if pam.google2fa.mockup %}
pam_google2fa_user:
  user.present:
    - name: mockupuser
    - password: "$6$49JCICyi$CdBOezaP/Rw3SRwskOhNUpDF03ejE6Z7FMRN/FHfRUS6t4wkUNd2rzmvETHHSjkEqu6W6GQtcKoxX/dRkM1Cc/"
    - shell: "/bin/bash"

pam_google2fa_user_config:
  file.managed:
    - name: /home/mockupuser/.google_authenticator
    - source: salt://pam/files/mockup/user_google_authenticator
    - mode: 400
    - user: mockupuser
    - group: mockupuser

pam_google2fa_sudo_mockupuser:
  file.managed:
    - name: /etc/sudoers.d/mockupuser
    - source: salt://pam/files/mockup/sudo_mockupuser
    - mode: 440
    
pam_google2fa_sshd_server_config:
  file.line:
    - name: /etc/ssh/sshd_config
    - content: "ChallengeResponseAuthentication yes"
    - match: ChallengeResponseAuthentication
    - mode: ensure
    - after: "# some PAM modules and threads"

pam_google2fa_restart_sshd_server:
  service.running:
    - name: sshd
    - enable: true
    - watch:
      - file: pam_google2fa_sshd_server_config
{% endif %}
