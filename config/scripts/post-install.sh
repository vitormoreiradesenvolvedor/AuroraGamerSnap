#!/usr/bin/env bash
set -oue pipefail

# 1. Habilitar Serviços Necessários
systemctl enable snapd.socket
systemctl enable mullvad-daemon.service # Correção Mullvad

# 2. Configuração Global de TLS e Criptografia
update-crypto-policies --set LEGACY

# Força o OpenSSL a aceitar SECLEVEL 0 (necessário para SQL Server antigo)
sed -i 's/CipherString = @SECLEVEL=2/CipherString = @SECLEVEL=0/g' /etc/crypto-policies/back-ends/openssl.config || true

# 3. Correção Estrutural para o Snap
# No Aurora, /root -> /var/roothome. Criamos o diretório real para evitar erro de "Not a directory"
mkdir -p /var/roothome/snap
ln -s /var/lib/snapd/snap /snap

# 4. Utilitário de Primeiro Boot (aurora-first-setup)
cat <<BOOT > /usr/bin/aurora-first-setup
#!/bin/bash
# Correção do DBeaver e ujust
FILE="/var/lib/flatpak/app/io.dbeaver.DBeaverCommunity/current/active/files/jre/conf/security/java.security"
[ -f "\$FILE" ] && sudo sed -i 's/TLSv1, TLSv1.1, //g' "\$FILE"
ujust devmode
ujust install-gaming-flatpaks
snap install snap-store
BOOT
chmod +x /usr/bin/aurora-first-setup