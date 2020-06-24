sudo apt-get dist-upgrade
sudo apt-get update
apt-cache policy build-essential
ls /etc/apt/sources.list.d
sudo apt-get -y install build-essential patch ruby-dev zlib1g-dev liblzma-dev ruby wget
mkdir /home/ubuntu/.ruby
mkdir /home/ubuntu/.bundle
mkdir /home/ubuntu/.nvm
echo 'export GEM_HOME=/home/ubuntu/.ruby' >> /home/ubuntu/.profile
echo 'export PATH="$PATH:/home/ubuntu/.ruby/bin"' >> /home/ubuntu/.profile
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | PROFILE=/home/ubuntu/.profile bash
source /home/ubuntu/.profile
gem install bundler
gem install nokogiri
nvm install 12.18.1
nvm alias default 12.18.1
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
