#!/bin/bash

# Vérifier que le nom de l'agent est bien passé en argument
if [ -z "$1" ]; then
  echo "❌ Utilisation : $0 <agent_name>"
  exit 1
fi

AGENT_NAME="$1"


# Exécuter le playbook avec le paramètre
ansible-playbook lab_agent_remove.yml \
  --ask-vault-pass \
  -e agent_name="$AGENT_NAME"






# #!/bin/bash
# set -e

# VAULT_PASS_FILE="$HOME/.vault_pass.txt"
# echo 'password' > "$VAULT_PASS_FILE"
# chmod 600 "$VAULT_PASS_FILE"

# if [ -z "$1" ]; then
#   echo "❌ Utilisation : $0 <agent_name>"
#   exit 1
# fi

# AGENT_NAME="$1"
# echo "🔍 Suppression de l’agent : $AGENT_NAME"

# ansible-playbook /home/hichem/jenkins-lab-02/lab_agent_remove.yml \
#   --vault-password-file "$VAULT_PASS_FILE" \
#   -e agent_name="$AGENT_NAME" >> /tmp/agent_remove.log 2>&1

