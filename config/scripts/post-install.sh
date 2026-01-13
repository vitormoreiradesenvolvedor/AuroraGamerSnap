#!/usr/bin/env bash
set -oue pipefail

echo "--- Ativando TLS 1.0 (Sistema) ---"
update-crypto-policies --set LEGACY

echo "--- Configurando links simbólicos ---"
systemctl enable snapd.socket
ln -s /var/lib/snapd/snap /snap

echo "--- Customização DBeaver (TLS 1.0 + Pin) ---"
# O comando de mask e alteração de segurança
flatpak mask io.dbeaver.DBeaverCommunity || true

# Script para rodar no primeiro boot do usuário para garantir DBeaver e Ujust
cat <<BOOT > /usr/bin/aurora-first-setup
#!/bin/bash
# Desbloqueia TLS no Java do DBeaver Flatpak
FILE="/var/lib/flatpak/app/io.dbeaver.DBeaverCommunity/current/active/files/jre/conf/security/java.security"
[ -f "\$FILE" ] && sed -i 's/TLSv1, TLSv1.1, //g' "\$FILE"

# Ativa as ferramentas ujust solicitadas
ujust devmode
ujust install-gaming-flatpaks
snap install snap-store
BOOT
chmod +x /usr/bin/aurora-first-setup
