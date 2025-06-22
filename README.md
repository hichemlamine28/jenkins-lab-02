# 🧪 Jenkins Lab 02 — Automatisation CI/CD avec Ansible & Agents Éphémères

[![Built with Jenkins](https://img.shields.io/badge/Built%20With-Jenkins-blue?logo=jenkins)](https://www.jenkins.io/)
[![Groovy](https://img.shields.io/badge/Script-Groovy-4298B8?logo=apache-groovy)](https://groovy-lang.org/)
[![Ansible](https://img.shields.io/badge/Automation-Ansible-EE0000?logo=ansible)](https://www.ansible.com/)
[![Terraform](https://img.shields.io/badge/Infra-Terraform-7B42BC?logo=terraform)](https://www.terraform.io/)
[![KVM](https://img.shields.io/badge/Virtualization-KVM-ff0000?logo=linux)](https://www.linux-kvm.org/)
[![QEMU](https://img.shields.io/badge/Emulation-QEMU-FF6600?logo=qemu)](https://www.qemu.org/)
[![Libvirt](https://img.shields.io/badge/API-libvirt-000000?logo=linux)](https://libvirt.org/)
[![Ubuntu](https://img.shields.io/badge/OS-Ubuntu-E95420?logo=ubuntu)](https://ubuntu.com/)
[![Java](https://img.shields.io/badge/Java-OpenJDK%2021-blue?logo=java)](https://openjdk.org/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-Automated-007ec6?logo=githubactions)](https://en.wikipedia.org/wiki/CI/CD)
[![Groovy](https://img.shields.io/badge/DSL-Groovy-8F4BFF?logo=groovy)](https://groovy-lang.org/)
[![Shell](https://img.shields.io/badge/Scripting-Bash-1f425f.svg?logo=gnubash)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/Inventory-Python%203.10+-3670A0?logo=python)](https://python.org)
[![Infrastructure](https://img.shields.io/badge/Topology-Master--Agents-orange?logo=networkx)](https://www.jenkins.io/doc/book/using/using-agents/)
[![Ephemeral Agents](https://img.shields.io/badge/Agents-Ephemeral-lightgrey?logo=jenkins)]
[![thinBackup](https://img.shields.io/badge/Backup-thinBackup-2ECC71?logo=databricks)](https://plugins.jenkins.io/thinbackup/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/hichemlamine28/jenkins-lab-02?style=social)](https://github.com/hichemlamine28/jenkins-lab-02/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/hichemlamine28/jenkins-lab-02?style=social)](https://github.com/hichemlamine28/jenkins-lab-02/network)
[![Last commit](https://img.shields.io/github/last-commit/hichemlamine28/jenkins-lab-02)](https://github.com/hichemlamine28/jenkins-lab-02/commits)

---

## 🚀 Présentation du projet

Ce dépôt propose un **laboratoire Jenkins complet et automatisé avec Ansible**, utilisant des **agents éphémères** (créés et détruits dynamiquement à la demande).

### ⚙️ Objectif

> Fournir une plateforme Jenkins dynamique, reproductible et légère, capable de **lancer des jobs CI/CD avec des agents créés à la volée**, puis supprimés automatiquement après exécution ou délai.

> 🔄 Contrairement à [`jenkins-lab-01`](https://github.com/hichemlamine28/jenkins-lab-01) où les agents sont statiques, **ce lab active les agents à la demande (ephemeral) pour chaque job**.

---

## 🧱 Prérequis

- 1+ VM Ubuntu (testé avec 4)
- Le master Jenkins **doit avoir la virtualisation imbriquée (nested virtualization) activée** *(gérée automatiquement via Ansible)*
- Accès SSH valide entre master et agents
- Python 3.10+
- Ansible, libvirt, kvm, qemu
- Terraform (optionnel pour provisioning alternatif)

---

## 🗂️ Structure du projet

```bash
jenkins-lab/
├── ansible.cfg
├── inventory.ini                  # inventaire statique temporaire
├── inventory_dynamic.py          # génération d’inventaire dynamique
├── lab_jenkins.yml               # playbook principal (installation & config)
├── lab_jenkins.sh                # exécution automatisée
├── lab_agent_create.yml          # création d’agent éphémère
├── lab_agent_remove.yml          # suppression d’agent
├── lab_agent_template_create.yml # création d’un template libvirt
├── lab_agent_template_remove.yml # suppression du template
├── group_vars/
│   └── all/
│       └── main.yml              # login, password Jenkins (vault)
├── roles/
│   ├── common/                   # installation Java, dépendances
│   │   └── tasks/main.yml
│   └── jenkins/                  # installation Jenkins & configuration
│       ├── defaults/main.yml
│       ├── handlers/main.yml
│       ├── tasks/main.yml
│       └── templates/
│           ├── 1_install_plugins.groovy.j2
│           ├── 2_login.groovy.j2
│           ├── 3_configure.groovy.j2
│           ├── 4_disable_setup.groovy.j2
│           ├── 5_add_jenkins_credential.groovy.j2
│           ├── 6_add_jenkins_agents.groovy.j2
│           └── check_script_execution.groovy.j2


🧪 Déploiement automatisé
🐍 Préparation de l’environnement Python
```bash
python3 -m venv venv
source venv/bin/activate
pip install ansible passlib lxml libvirt-python
ansible-galaxy collection install community.libvirt
sudo apt install pkg-config libvirt-dev python3-dev -y
```

🚀 Exécution du LAB Jenkins

📌 Étapes :

Génération de l’inventaire dynamique :

```bash
./inventory_dynamic.py
```

Lancement du playbook principal :

```bash
ansible-playbook lab_jenkins.yml -i inventory.ini --ask-vault-pass
```

Ou exécution tout-en-un :

```bash
./lab_jenkins.sh
```

🖥️ Création / Suppression Agents & Templates

🔧 Gestion des agents :

```bash
ansible-playbook lab_agent_create.yml --ask-vault-pass
ansible-playbook lab_agent_remove.yml --ask-vault-pass -e vm_name=agent_949f
```

🧱 Gestion des templates :

```bash
ansible-playbook lab_agent_template_create.yml -i inventory.ini --ask-vault-pass
ansible-playbook lab_agent_template_remove.yml -i inventory.ini --ask-vault-pass
```

🛠️ Jenkins CLI (depuis le master)

```bash
wget http://localhost:{{ jenkins_port }}/jnlpJars/jenkins-cli.jar

java -jar jenkins-cli.jar -s http://localhost:{{ jenkins_port }} -auth admin:password version

alias jenkins='java -jar ~/jenkins-cli.jar -s http://localhost:{{ jenkins_port }} -auth admin:password'

jenkins help
jenkins who-am-i
jenkins version
```

🔑 Connexion par SSH (alternative)

```bash
curl -Lv http://localhost:{{ jenkins_port }}/login 2>&1 | grep -i 'x-ssh-endpoint'

ssh -p 2222 admin@localhost version
```

💾 Backup Jenkins avec thinBackup
```bash
sudo mkdir /var/lib/jenkins/jenkins_backup
sudo chown -R jenkins /var/lib/jenkins/jenkins_backup
```



🧩 Fonctionnalités automatisées
```text
✅ Détection dynamique des VMs (1 master + N agents)
✅ Préparation système des VMs (update, Java, libvirt...)
✅ Installation & configuration complète de Jenkins
✅ Activation de la nested virtualization sur le master
✅ Configuration de Jenkins via scripts Groovy
✅ Installation automatique de plugins Jenkins essentiels
✅ Envoi des clés SSH vers les agents
✅ Gestion automatique des credentials sur le master
✅ Génération d’agents éphémères selon les jobs
✅ Suppression automatique après timeout configurable
✅ Inventaire dynamique avec Python
✅ Intégration thinBackup
✅ Compatible avec cloud ou infrastructure locale
```


🧠 Différences avec jenkins-lab-01

```text
jenkins-lab-01                                  jenkins-lab-02 (ce projet)
Agents statiques                                ✅ Agents éphémères dynamiques
Création manuelle des VMs agents                ✅ Création/déstruction auto avec libvirt
Jenkins full config (Groovy, plugins, SSH)      ✅ Jenkins full config (Groovy, plugins, SSH)
Inventaire dynamique                            ✅ Inventaire dynamique
Pas de gestion de nested virt	                  ✅ Nested virt activée automatiquement
```

📄 Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE.📄 Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE.


🤝 Contributions

Les contributions sont bienvenues !  
Forkez, améliorez, proposez vos idées ou PRs 🙏


👤 Auteur
Hichem Elamine
💼 DevSecOps | Cloud | Automation
🌍 LinkedIn | GitHub