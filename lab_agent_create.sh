#!/bin/bash
ansible-playbook lab_agent_create.yml --ask-vault-pass





# #!/bin/bash

# LOG_FILE="/tmp/agent_provision.log"
# VAULT_PASS_FILE="$HOME/.vault_pass.txt"

# echo "[INFO] Script lab_agent_create.sh lancé le $(date)" >> "$LOG_FILE"

# echo 'password' > "$VAULT_PASS_FILE"
# chmod 600 "$VAULT_PASS_FILE"  # sécurité

# # Exécution avec log complet
# ansible-playbook /home/hichem/jenkins-lab-02/lab_agent_create.yml \
#     --vault-password-file "$VAULT_PASS_FILE" >> "$LOG_FILE" 2>&1

# echo "[INFO] Script terminé avec code $? à $(date)" >> "$LOG_FILE"
