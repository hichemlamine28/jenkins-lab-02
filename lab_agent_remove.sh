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

# echo 'ton_mot_de_passe_vault' > ~/.vault_pass.txt
# chmod 600 ~/.vault_pass.txt  # pour la sécurité
# ansible-playbook lab_agent_remove.yml --vault-password-file ~/.vault_pass.txt


# # Vérifier que le nom de l'agent est bien passé en argument
# if [ -z "$1" ]; then
#   echo "❌ Utilisation : $0 <agent_name>"
#   exit 1
# fi

# AGENT_NAME="$1"

# # Exécuter le playbook avec le paramètre
# ansible-playbook lab_agent_remove.yml \
#   --vault-password-file "$VAULT_PASS_FILE" \
#   -e agent_name="$AGENT_NAME"