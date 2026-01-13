#!/usr/bin/env bash
set -oue pipefail

echo "--- Configurando Repositório Mullvad ---"
# Importa a chave GPG oficial para que o rpm-ostree confie nos pacotes
rpm --import https://repository.mullvad.net/rpm/mullvad-keyring.asc

# Descarrega o ficheiro .repo oficial diretamente para a pasta de repositórios do sistema
curl -Lo /etc/yum.repos.d/mullvad.repo https://repository.mullvad.net/rpm/stable/mullvad.repo