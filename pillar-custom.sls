# vim: ft=yaml
# Custom Pillar Data for pam

pam:
  enabled: true
  google2fa:
    enabled: true
    pkg: libpam-google-authenticator
    ssh: true
    sudo: true
    mockup: true
  services:
    cron:
      - include: common-auth
      - type: session
        control: required
        module: pam_loginuid.so
        pkg: libpam-modules
      - type: session
        control: required
        module: pam_env.so
      - type: session
        control: required
        module: pam_env.so
        args:
          - envfile=/etc/default/locale
      - include: common-account
      - include: common-session-noninteractive
      - type: session
        control: required
        module: pam_limits.so
