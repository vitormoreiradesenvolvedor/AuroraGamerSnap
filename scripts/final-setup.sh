#!/usr/bin/env bash
set -e

echo ">>> Iniciando configuração final do Usuário (13/01/2026)..."

# 1. Configurar Snap e Instalar Snap Store
# O link simbólico é necessário no Fedora/Aurora para o Snap classic funcionar
if [ ! -L /snap ]; then
    echo "Criando symlink para /snap..."
    sudo ln -s /var/lib/snapd/snap /snap
fi
echo "Instalando Snap Store..."
sudo snap install snap-store

# 2. Instalar Flatpaks de Gaming (Steam, Lutris, etc)
# Usa o script padrão do ujust que já vem na imagem
echo "Instalando pacote Gaming..."
ujust install-gaming-flatpaks

# 3. DBeaver: Instalação e Pinagem
echo "Instalando DBeaver Community..."
flatpak install -y flathub io.dbeaver.DBeaverCommunity

echo "Pinando DBeaver (mask) para não atualizar mais..."
flatpak mask io.dbeaver.DBeaverCommunity

# 4. DBeaver: Hack do TLS 1.0 (Java Security)
# Criamos um override para usar um arquivo de segurança modificado
CONFIG_DIR="$HOME/.var/app/io.dbeaver.DBeaverCommunity/config"
mkdir -p "$CONFIG_DIR"

# Copia a configuração padrão do Java do sistema (que já está em LEGACY graças ao passo de build)
# ou cria um arquivo específico permissivo.
cat <<EOF > "$CONFIG_DIR/java.security.custom"
jdk.tls.disabledAlgorithms=SSLv3, RC4, DES, MD5withRSA, DH keySize < 1024, EC keySize < 224, 3DES_EDE_CBC
# Note que TLSv1 e TLSv1.1 foram REMOVIDOS da lista de desabilitados acima
EOF

echo "Aplicando override de segurança no DBeaver..."
flatpak override --user --env=JAVA_TOOL_OPTIONS="-Djava.security.properties=/var/config/java.security.custom" io.dbeaver.DBeaverCommunity

# 5. Slack (via Flatpak é melhor, mas pode ser Snap se preferir)
flatpak install -y flathub com.slack.Slack

echo ">>> TUDO PRONTO! Reinicie o sistema para garantir que o Snap carregue os ícones."
