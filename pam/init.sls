# vim: ft=sls
# Init pam
{%- from "pam/map.jinja" import pam with context %}
{# Below is an example of having a toggle for the state #}

{% if pam.enabled %}
include:
  {% if pam.google2fa.enabled -%}
  - pam.google2fa
  {%- endif %}
  - pam.install
  - pam.config
{% else %}
'pam-formula disabled':
  test.succeed_without_changes
{% endif %}
