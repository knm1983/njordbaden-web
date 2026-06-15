#!/bin/bash
set -e
echo "=== NjordBaden deploy $(date) ==="

SRC_DIR=/root/njordbaden-web
WEB_DIR=/var/www/njordbaden-web

cd "$SRC_DIR"
GIT_SSH_COMMAND="ssh -i /root/.ssh/github_deploy" git pull origin main

echo "=== Deploy files ==="
mkdir -p "$WEB_DIR"
cp -r "$SRC_DIR/images" "$WEB_DIR/"
cp "$SRC_DIR/index.html" "$WEB_DIR/"
cp -r "$SRC_DIR/download" "$WEB_DIR/"
chown -R www-data:www-data "$WEB_DIR"

echo "=== Caddy config ==="
mkdir -p /etc/caddy/sites
cp "$SRC_DIR/deploy/njordbaden.conf" /etc/caddy/sites/njordbaden.conf
echo "import sites/*" > /etc/caddy/Caddyfile
systemctl reload caddy

echo "=== Deploy OK ==="
