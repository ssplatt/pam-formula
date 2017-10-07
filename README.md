# pam-formula

Install and configure PAM modules.

## Configure PAM service under /etc/pam.d

This formula supports the definition of any pam service file under /etc/pam.d.
Each service file should be its own mapping under the pillar pam.services
in which the key is the service/file name and the value is a list of chain
modules. Each chain module should itself be a mapping which specifies the
following values:

- **type**: The management group that the rule corresponds to
  (i.e., one of "account", "auth", "password", or "session")
- **control**: Requisite level of rule (i.e., one of "required", "requisite",
  "sufficient", or "optional")
- **module**: Module from which to apply the rule (e.g., "pam_unix.so")

The mapping may optionally specify the following additional values

- **args**: A list of arguments to pass to the pam module
- **pkg**: A package which is required to make the module available

A mapping may also consist of a single `include` parameter, naming another
service file to include

**Example**:
```yaml
pam:
  enabled: true
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
```
*produces the file /etc/pam.d/cron:*
```

@include common-auth
session required pam_loginuid.so
session required pam_env.so
session required pam_env.so envfile=/etc/default/locale
@include common-account
@include common-session-noninteractive
session required pam_limits.so
```

Required module packaged may also be specified in a list under `pam.module_pkgs`
instead of being specified individually within a service chain

## Available States
### google2fa
Installs and configures the libpam-google-authenticator Debian package. Has a 'mockup' switch to get the correct ssh and sudo things in place for testing. A package for Debian 6 has been created using fpm.

Defaults:
```
pam:
  enabled: false
  google2fa:
    enabled: false
    pkg: libpam-google-authenticator
    ssh: false
    sudo: false
    mockup: false
```

Testing config:
```
pam:
  enabled: true
  google2fa:
    enabled: true
    pkg: libpam-google-authenticator
    ssh: true
    sudo: true
    mockup: true
```

Look in the pam/files/mockup folder for information on setting up and testing Google Auth.

### ldap
the general idea has been started but no code has actually be written.

Defaults:
```
pam:
  enabled: false
  ldap:
    enabled: false
    pkg: libpam-ldap
    service_pkg: libpam-ldapd
```

## How to use Vagrant and Kitchen
Install and setup brew:
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install vagrant with brew:
```
brew install cask
brew cask install vagrant
```

Install test-kitchen:
```
sudo gem install test-kitchen
sudo gem install kitchen-vagrant
sudo gem install kitchen-salt
```

Run a converge on the default configuration:
```
kitchen converge default
```
