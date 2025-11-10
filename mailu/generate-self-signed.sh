#!/usr/bin/env bash
# Generates a self-signed cert for mail.milagros.me
# Usage: ./generate-self-signed.sh
set -euo pipefail
mkdir -p "$(dirname "$0")"/certs || true
CERT_DIR="$(pwd)/mailu/certs"
mkdir -p "$CERT_DIR"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$CERT_DIR/privkey.pem" \
  -out "$CERT_DIR/fullchain.pem" \
  -subj "/CN=mail.milagros.me"
chmod 600 "$CERT_DIR/privkey.pem"
chmod 644 "$CERT_DIR/fullchain.pem"
echo "Created self-signed cert in $CERT_DIR"
