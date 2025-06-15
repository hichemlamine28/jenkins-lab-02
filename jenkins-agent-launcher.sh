#!/bin/bash
set -euo pipefail

PLAYBOOK_DIR="/home/hichem/jenkins-lab-02"
PLAYBOOK_NAME="lab_jenkins.yml"
PRIVATE_KEY="/tmp/.ssh/jenkins_master_id_rsa"
VAULT_PASS_FILE="/tmp/vault_pass.txt"
AGENT_INFO_FILE="/tmp/jenkins-agent-info.txt"

echo "[INFO] Création de l'agent éphémère via Ansible..."
cd "$PLAYBOOK_DIR"

# Préparer les fichiers temporaires
echo "master" > "$VAULT_PASS_FILE"
export LIBVIRT_DEFAULT_URI=qemu:///system

# Exécuter le playbook
ansible-playbook "$PLAYBOOK_NAME" \
  -i inventory.ini \
  --private-key="$PRIVATE_KEY" \
  --vault-password-file="$VAULT_PASS_FILE"

# Nettoyage
rm -f "$VAULT_PASS_FILE"

# Attente de la génération du fichier info (30s max)
echo "[INFO] Attente de $AGENT_INFO_FILE..."
for i in {1..30}; do
  [[ -f "$AGENT_INFO_FILE" ]] && break
  echo "[INFO] Fichier non trouvé, tentative $i/30..."
  sleep 1
done

if [[ ! -f "$AGENT_INFO_FILE" ]]; then
  echo "[ERROR] Timeout : $AGENT_INFO_FILE non trouvé."
  exit 1
fi

# Vérification du contenu
source "$AGENT_INFO_FILE"

if [[ -z "${name:-}" || -z "${ip:-}" ]]; then
  echo "[ERROR] Variables 'name' ou 'ip' manquantes dans $AGENT_INFO_FILE."
  exit 1
fi

echo "[INFO] Agent généré : $name ($ip)"
echo "[INFO] Infos disponibles dans $AGENT_INFO_FILE pour Jenkins Master."

exit 0
