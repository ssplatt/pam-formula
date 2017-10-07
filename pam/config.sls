{%- from "pam/map.jinja" import pam with context %}

{% for svc, chain in pam.services.items() %}
pam_service_{{ svc }}:
  file.managed:
    - name: /etc/pam.d/{{ svc }}
    - source: salt://pam/files/pamd_service.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - chain: {{ chain }}
{% endfor %}
