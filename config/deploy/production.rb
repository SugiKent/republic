set :rails_env, "production"
set :unicorn_rack_env, "production"

role :app, %w{ec2-user@99.999.999.999}
role :web, %w{ec2-user@99.999.999.999}
role :db,  %w{ec2-user@99.999.999.999}

server '99.999.999.999', user: 'ec2-user', roles: %w{web db app}

set :ssh_options, {
  keys: %w(~/.ssh/aws_no_key.pem),
  forward_agent: false,
  auth_methods: %w(publickey)
}
