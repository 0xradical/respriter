#!/usr/bin/env sh

rm -f /etc/nginx/conf.d/*

for subdomain in `ls /var/www`; do
  echo "Configuring $subdomain.$DOMAIN";

  cat <<EOT > /etc/nginx/conf.d/$subdomain.conf
server {
  listen 80;
  listen [::]:80;

  root /var/www/$subdomain;
  index index.html;

  server_name $subdomain.$DOMAIN;

  location / {
    try_files \$uri \$uri/ =404;
  }
}
EOT
done;

exec "$@"
