{%- from "pam/map.jinja" import pam with context %}
{%- for svc, chain in pam.services.items() %}
  {%- for link in chain %}
    {%- if link.pkg is defined and link.pkg not in pam.module_pkgs %}
      {% do pam.module_pkgs.append(link.pkg) %}
    {%- endif %}
  {%- endfor %}
{%- endfor %}

pam_required_pkgs:
  pkg.installed:
    - pkgs: {{ pam.module_pkgs }}
