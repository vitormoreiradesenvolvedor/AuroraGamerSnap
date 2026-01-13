#!/usr/bin/env bash
set -oue pipefail

echo "--- Configurando Repositório Mullvad ---"
# Importa a chave GPG oficial
rpm --import https://repository.mullvad.net/rpm/mullvad-keyring.asc

# Baixa o arquivo do repositório diretamente para a pasta correta
curl -Lo /etc/yum.repos.d/mullvad.repo https://repository.mullvad.net/rpm/stable/x86_64/mullvad.repo