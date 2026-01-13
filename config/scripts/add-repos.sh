#!/usr/bin/env bash
set -oue pipefail

echo "--- Importando Chave GPG Mullvad ---"
# Importa a chave diretamente para o banco de dados de chaves do RPM
rpm --import https://repository.mullvad.net/rpm/mullvad-keyring.asc

echo "--- Adicionando Repositório Mullvad ---"
curl -Lo /etc/yum.repos.d/mullvad.repo https://repository.mullvad.net/rpm/stable/x86_64/mullvad.repo
