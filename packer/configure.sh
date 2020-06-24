sudo apt-get update
sudo apt-get -y install build-essential patch ruby-dev zlib1g-dev liblzma-dev ruby wget
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
mkdir /home/ubuntu/.ruby
mkdir /home/ubuntu/.bundle
mkdir /home/ubuntu/.nvm
export GEM_HOME=/home/ubuntu/.ruby
export PATH="$PATH:/home/ubuntu/.ruby/bin"
echo 'export GEM_HOME=/home/ubuntu/.ruby' >> /home/ubuntu/.bashrc
echo 'export PATH=\"$PATH:/home/ubuntu/.ruby/bin\"' >> /home/ubuntu/.bashrc
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
. /home/ubuntu/.bashrc
. /home/ubuntu/.nvm/nvm.sh
gem install bundler
nvm install 12.18.1