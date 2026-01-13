#!/usr/bin/env bash
set -ouex pipefail

# 1. Ativar política de criptografia LEGACY (TLS 1.0/1.1) no sistema todo
# Isso afeta o OpenSSL e o Kernel
update-crypto-policies --set LEGACY

# 2. Garantir permissão de execução no script final
chmod +x /usr/bin/final-setup.sh
