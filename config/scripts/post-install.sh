#!/usr/bin/env bash
set -oue pipefail

echo "--- Habilitando TLS 1.0 (Modo Legacy) ---"
update-crypto-policies --set LEGACY

echo "--- Configurando Suporte ao Snap ---"
systemctl enable snapd.socket
ln -s /var/lib/snapd/snap /snap

echo "--- Customizando DBeaver (Flatpak) ---"
# Mascarando para não atualizar
flatpak mask io.dbeaver.DBeaverCommunity || true

# Modificando java.security para permitir TLS 1.0 dentro do Flatpak
# Nota: Como o Flatpak é montado em runtime, este comando tenta localizar 
# os arquivos persistentes se existirem ou prepara o ambiente.
DB_JAVA_SEC="/var/lib/flatpak/app/io.dbeaver.DBeaverCommunity/current/active/files/jre/conf/security/java.security"
if [ -f "$DB_JAVA_SEC" ]; then
    sed -i 's/TLSv1, TLSv1.1, //g' "$DB_JAVA_SEC"
fi

echo "--- Preparando Automação ujust ---"
# Comandos ujust para rodar no primeiro login do usuário
mkdir -p /etc/skel/.config/autostart
cat <<UPDATE > /usr/bin/setup-aurora-custom
#!/bin/bash
ujust devmode
ujust install-gaming-flatpaks
snap install snap-store
UPDATE
chmod +x /usr/bin/setup-aurora-custom
