#!/bin/bash
set -e

LOG_FILE="/var/log/user-data.log"
exec > >(tee -a ${LOG_FILE}) 2>&1

echo "===== User data script started ====="

dnf update -y

dnf install -y nginx git

systemctl enable nginx
systemctl start nginx

WEB_ROOT="/usr/share/nginx/html"

rm -rf ${WEB_ROOT}/*

git clone https://github.com/eslam-devops/-my-portfolio.git /tmp/my-portfolio

cp -r /tmp/my-portfolio/* ${WEB_ROOT}/

# Permissions
chown -R nginx:nginx ${WEB_ROOT}
chmod -R 755 ${WEB_ROOT}

systemctl restart nginx

echo "===== Portfolio deployed successfully ====="
echo "===== User data script completed ====="
