#!/usr/bin/env bash
set -oue pipefail

echo "--- Ativando TLS 1.0 e Links do Snap ---"
update-crypto-policies --set LEGACY
systemctl enable snapd.socket
ln -s /var/lib/snapd/snap /snap

# Criação do utilitário de primeiro boot
cat <<BOOT > /usr/bin/aurora-first-setup
#!/bin/bash
# Desbloqueia TLS no DBeaver e roda ujust
FILE="/var/lib/flatpak/app/io.dbeaver.DBeaverCommunity/current/active/files/jre/conf/security/java.security"
[ -f "\$FILE" ] && sed -i 's/TLSv1, TLSv1.1, //g' "\$FILE"
ujust devmode
ujust install-gaming-flatpaks
snap install snap-store
BOOT
chmod +x /usr/bin/aurora-first-setup