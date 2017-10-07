require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/pam.d/sudo') do
  it { should exist }
  its(:content) { should match /auth  required  pam_google_authenticator.so/ }
end

describe file('/etc/pam.d/sshd') do
  it { should exist }
  its(:content) { should match /auth  required  pam_google_authenticator.so/ }
end

describe package('libpam-google-authenticator') do
  it { should be_installed }
end

describe file('/etc/skel/.google_authenticator') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

expected_cron_service = <<EOF

@include common-auth
session required pam_loginuid.so
session required pam_env.so
session required pam_env.so envfile=/etc/default/locale
@include common-account
@include common-session-noninteractive
session required pam_limits.so
EOF

describe package('libpam-modules') do
  it { should be_installed }
end

describe file('/etc/pam.d/cron') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  its(:content) { should be == expected_cron_service }
end
