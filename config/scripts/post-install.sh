#!/usr/bin/env bash
set -oue pipefail

echo "--- Ativando TLS 1.0 no Sistema ---"
update-crypto-policies --set LEGACY

echo "--- Configurando Suporte ao Snap ---"
systemctl enable snapd.socket
ln -s /var/lib/snapd/snap /snap

echo "--- Utilitário de Primeiro Boot ---"
cat <<BOOT > /usr/bin/aurora-setup
#!/bin/bash
# Desbloqueia TLS no DBeaver Flatpak
FILE="/var/lib/flatpak/app/io.dbeaver.DBeaverCommunity/current/active/files/jre/conf/security/java.security"
if [ -f "\$FILE" ]; then
    sudo sed -i 's/TLSv1, TLSv1.1, //g' "\$FILE"
fi

# Pinagem (Mask) para evitar updates do DBeaver
flatpak mask io.dbeaver.DBeaverCommunity

# Comandos ujust e snap-store solicitados
ujust devmode
ujust install-gaming-flatpaks
snap install snap-store
BOOT

chmod +x /usr/bin/aurora-setup