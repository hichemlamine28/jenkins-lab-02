#!/usr/bin/env python3
import socket

def get_local_ip():
    """Récupère l'IP IPv4 locale utilisée pour la sortie par défaut."""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return ip

def generate_inventory(ip, user="hichem", key_path="/home/hichem/.ssh/id_rsa", filename="inventory_local.ini"):
    content = f"""[ephemeral_agents]
agent_local ansible_host={ip} ansible_user={user} ansible_ssh_private_key_file={key_path}
"""
    with open(filename, "w") as f:
        f.write(content)
    print(f"Inventaire généré dans {filename} avec l'IP {ip}")

if __name__ == "__main__":
    ip = get_local_ip()
    generate_inventory(ip)
