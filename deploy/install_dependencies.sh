!#/bin/bash
source /home/ubuntu/config.sh
sudo apt-get update
sudo apt-get -y install build-essential patch ruby-dev zlib1g-dev liblzma-dev ruby-dev ruby wget nodejs npm
cd /home/ubuntu
wget ${AWS_CODE_DEPLOY_RESOURCE_KIT}
chmod +x ./install
sudo ./install auto
cd /home/ubuntu
git clone https://${GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/classpert/respriter.git
mkdir /home/ubuntu/.ruby 2&>1
mkdir /home/ubuntu/.bundle
echo 'export GEM_HOME=/home/ubuntu/.ruby' >> /home/ubuntu/.bashrc
echo 'export PATH="$PATH:/home/ubuntu/.ruby/bin"' >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc
cd /home/ubuntu/respriter
bundle install
export SPRITE_VERSION=$(node -p "require('./package.json').version")
export SPRITE_URL=https://elements-prd.classpert.com/${SPRITE_VERSION}/svgs/sprites/\{tags,brand,i18n,icons,providers\}.svg
./bin/build --sprite-version=$SPRITE_VERSION --sprite-url=$SPRITE_URL