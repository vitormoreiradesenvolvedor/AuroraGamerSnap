#!/usr/bin/env bash
set -oue pipefail

# 1. Criar grupos que o ujust tentou criar e falhou
# Isso evita os erros de "grupo não existe" no setup
groupadd -f docker
groupadd -f libvirt
groupadd -f incus-admin

# 2. Habilitar Serviços
systemctl enable snapd.socket
systemctl enable mullvad-daemon.service

# 3. TLS 1.0 e OpenSSL Legacy (Para SQL Server)
update-crypto-policies --set LEGACY
sed -i 's/CipherString = @SECLEVEL=2/CipherString = @SECLEVEL=0/g' /etc/crypto-policies/back-ends/openssl.config || true

# 4. Correção Estrutural do Snap (Not a directory fix)
# Criamos o diretório real em /var e vinculamos
mkdir -p /var/lib/snapd/snap
ln -s /var/lib/snapd/snap /snap
# Correção específica para o erro /root/snap
mkdir -p /var/roothome/snap

# 5. Utilitário aurora-setup atualizado para 2026
cat <<BOOT > /usr/bin/aurora-setup
#!/bin/bash
# Como a base já é DX, não precisamos de ujust devmode
echo "Finalizando configurações..."

# Desbloqueia TLS no DBeaver
FILE="/var/lib/flatpak/app/io.dbeaver.DBeaverCommunity/current/active/files/jre/conf/security/java.security"
[ -f "\$FILE" ] && sudo sed -i 's/TLSv1, TLSv1.1, //g' "\$FILE"

# Corrigido: ujust para gaming em 2026
ujust install-system-flatpaks # Removido o 's' final se necessário

# Garante a instalação da Snap Store
snap install snap-store
BOOT

chmod +x /usr/bin/aurora-setup