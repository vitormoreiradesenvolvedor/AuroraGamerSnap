#!/usr/bin/env bash
set -oue pipefail

# 1. Habilitar Serviços (Mullvad precisa do daemon ativo)
systemctl enable snapd.socket
systemctl enable mullvad-daemon.service

# 2. TLS 1.0 e Segurança OpenSSL (Necessário para SQL Server)
update-crypto-policies --set LEGACY
# Força o nível de segurança para 0 no OpenSSL para permitir conexões legadas
sed -i 's/CipherString = @SECLEVEL=2/CipherString = @SECLEVEL=0/g' /etc/crypto-policies/back-ends/openssl.config || true

# 3. Correção do Snap (Evita erro de "Not a directory")
mkdir -p /var/roothome/snap
ln -s /var/lib/snapd/snap /snap

# 4. Utilitário de Primeiro Boot
cat <<BOOT > /usr/bin/aurora-setup
#!/bin/bash
# Desbloqueia TLS no DBeaver e roda automações
FILE="/var/lib/flatpak/app/io.dbeaver.DBeaverCommunity/current/active/files/jre/conf/security/java.security"
[ -f "\$FILE" ] && sudo sed -i 's/TLSv1, TLSv1.1, //g' "\$FILE"
flatpak mask io.dbeaver.DBeaverCommunity
ujust devmode
ujust install-gaming-flatpaks
snap install snap-store
BOOT
chmod +x /usr/bin/aurora-setup