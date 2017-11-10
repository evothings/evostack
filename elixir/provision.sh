# Add Erlang Solutions repo
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
rm erlang-solutions_1.0_all.deb

# Add Postgres repo
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdg main" >> /etc/apt/sources.list'
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -

# Update
apt-get update

# Install the Erlang/OTP platform and all of its applications
apt-get -y install esl-erlang

# Install Elixir
apt-get -y install elixir

# Requirements for Phoenix live reload
apt-get -y install inotify-tools

# Postgres and PostGIS
apt-get -y install postgresql-9.6 postgresql-9.6-postgis-2.3 postgresql-contrib-9.6

# Set password for postgres user :)
sudo -i -u postgres psql -c "ALTER USER postgres PASSWORD 'evostack99';"

# Nodejs
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt-get -y install nodejs


# As ubuntu user, install hex
sudo -i -u ubuntu mix local.hex --force

# As ubuntu user, install Phoenix
sudo -i -u ubuntu mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Just print out versions
elixir --version
nodejs --version
sudo -i -u ubuntu mix hex.info
sudo -i -u ubuntu mix phx.new --version
