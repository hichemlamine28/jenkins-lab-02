#!/usr/bin/env python3

import libvirt
import re
import sys

def get_domain_ips(domain):
    """Récupère les IPs IPv4 des interfaces réseau d'une VM."""
    ips = []
    try:
        ifaces = domain.interfaceAddresses(libvirt.VIR_DOMAIN_INTERFACE_ADDRESSES_SRC_LEASE)
        for (name, val) in ifaces.items():
            if val['addrs']:
                for addr in val['addrs']:
                    if addr['type'] == libvirt.VIR_IP_ADDR_TYPE_IPV4:
                        ips.append(addr['addr'])
    except Exception:
        pass
    return ips

def extract_vm_number(name):
    """Extrait le numéro de la VM depuis son nom : labvm1 → 1, labvm-2 → 2, etc."""
    match = re.search(r'labvm[-]?(\d+)', name)
    return int(match.group(1)) if match else float('inf')

def main():
    try:
        conn = libvirt.open('qemu:///system')
    except libvirt.libvirtError as e:
        print(f"Erreur connexion libvirt: {e}", file=sys.stderr)
        sys.exit(1)

    vms = {}

    # Récupère toutes les VMs actives
    for id in conn.listDomainsID():
        dom = conn.lookupByID(id)
        name = dom.name()
        ip_list = get_domain_ips(dom)
        ip = ip_list[0] if ip_list else "UNKNOWN"
        vms[name] = ip

    # Récupère les VMs inactives
    defined_domains = conn.listDefinedDomains()
    for name in defined_domains:
        if name not in vms:
            dom = conn.lookupByName(name)
            vms[name] = "OFFLINE"

    conn.close()

    # Trie les VMs par numéro
    sorted_vms = sorted(vms.items(), key=lambda item: extract_vm_number(item[0]))

    # Génère le contenu INI
    lines = []
    if sorted_vms:
        master_name, master_ip = sorted_vms[0]
        lines.append("[master]")
        lines.append(f"{master_name} ansible_host={master_ip}")
        lines.append("")

        agents = sorted_vms[1:]
        if agents:
            lines.append("[agents]")
            for name, ip in agents:
                lines.append(f"{name} ansible_host={ip}")
            lines.append("")

    # Ajoute les variables globales
    lines.append("[all:vars]")
    lines.append("ansible_user=ubuntu")
    lines.append("ansible_ssh_private_key_file=~/.ssh/id_rsa")

    # Écrit dans le fichier inventory.ini
    with open("inventory.ini", "w") as f:
        f.write("\n".join(lines))

    print("✅ Fichier inventory.ini généré avec succès.")

if __name__ == "__main__":
    main()
