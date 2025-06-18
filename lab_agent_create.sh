#!/bin/bash
ansible-playbook lab_agent_create.yml --ask-vault-pass



# #!/bin/bash

# echo 'ton_mot_de_passe_vault' > ~/.vault_pass.txt
# chmod 600 ~/.vault_pass.txt  # pour la sécurité
# ansible-playbook lab_agent_create.yml --vault-password-file ~/.vault_pass.txt