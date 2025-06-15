#!/bin/bash
./inventory_dynamic.py
ansible-playbook lab_jenkins.yml -i inventory.ini --ask-vault-pass
