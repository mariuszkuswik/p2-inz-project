# TODO 
- Dodać wszystkie repozytoria do porjektu, w katalogu Meta/repo_files można je wrzucić
- Utworzyć nową sieć bridgenet!
- Upewnić się czy wirtualizacja na danym hoście jest włączona, koniecne dla działania Terraform, sprawdzić to możemy przez:
```bash
egrep -wo 'vmx|svm' /proc/cpuinfo
lsmod | grep kvm
```
- Zmienić domyślne ścieżki dla ansible.iso itd., + uprawnienia do tych plików

### Zmiana targetu virsh 
```
export LIBVIRT_DEFAULT_URI=qemu:///system
```



sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Utworzenie interfejsu sieciowego bridge?
sudo nmcli connection add type bridge con-name nm-bridge2 ifname nm-bridge2
sudo nmcli connection up nm-bridge2


virsh net-start bridgenet
virsh net-autostart bridgenet


sudo ip link add name nm-bridge2 type bridge
sudo ip link set nm-bridge2 up
sudo ip addr add 192.168.1.150/24 dev nm-bridge2

sudo ip route add 192.168.1.0/24 dev nm-bridge2 metric 100




# Instalacja 
## WAŻNE 
1. Przed zainstaowaniem należy pobrać obraz rhel8 w formacie qcow2
```
ls p2-files/rhel-8.10-x86_64-kvm.qcow2
```
 
2. Domyślnym katalogiem wykonywania wszystkich komend jest katalog:
```
$HOME/services/p2-inz-project 
```

## Utworzenie repozytoriów
*Wszystkie kroki przedstawione są dla RH9/Rocky9*

### Instalacja repozytorium epel
```bash
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
```

### Podpięcie repozytorium mongo
```bash
cat >/etc/yum.repos.d/mongo.repo <<EOF
[mongo]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF
```

### Podpięcie repozytorium terraform
```bash
cat /etc/yum.repos.d/hashicorp.repo <<EOF
[hashicorp]
name=HashiCorp Stable - RHEL \$releasever
baseurl=https://rpm.releases.hashicorp.com/RHEL/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
EOF
```

## Instalacja paczek
```bash
dnf install qemu-kvm  libvirt virt-install terraform ansible mongocli.x86_64 genisoimage virt-manager bridge-utils -y 
```

## Usługi
```bash
systemctl enable --now libvirtd
systemctl enable --now virtqemud
```

## Aktuany user
Dodanie aktualnego użytkownika do grupy libvirt w celu nadania mu uprawnień do tworzenia zasobów
```bash
usermod -aG libvirt $USER
```

## Utworzenie storage poola virsh
Nazwa pooli ustawiona w terraform to default, katalog docelowy może być dowolny, tutaj podaję przykład katalogu "$HOME"/virsh-pool-default
```bash
mkdir -p /var/lib/libvirt/images/virsh-pool-default

# Skopiowanie tutaj wszystkich obrazów qcow i iso (?) 
# Nadanie uprawnień userowi 107 

# Terraform ma podaną sesję system, więc w przypadku virsh poole również tworzymy przez system
virsh --connect qemu:///system pool-define-as --name default --type dir --target /var/lib/libvirt/images/virsh-pool-default

virsh --connect qemu:///system pool-autostart default
virsh --connect qemu:///system pool-start default
```

Wykonujemy komendę potwierdzającą stworzenie poola
```bash
virsh --connect qemu:///system pool-list 

### Powinno zostać wyświetlone to co poniżej
 Name      State    Autostart
-------------------------------
 default   active   yes
```

## Pobranie obrazu rhel
[Link bezpośredni do obrazu qcow2 RedHat 8.1](https://access.cdn.redhat.com/content/origin/files/sha256/82/820853871801754056642ead33834fbe5640421b57e07f2c084684f4d1a7d2fe/rhel-8.10-x86_64-kvm.qcow2?user=a4836c0c2db2a65c751f9256436b1e82&_auth_=1743634281_b7e43a9073e6953440d169446614b734)

# Uruchamianie

## Zainicjowanie zmiennych
Zmienne należy zmienić w zależności od potrzeb
```bash
export TF_VAR_node_disk_path="$HOME"/p2/terra_kvm/meta/rhel/rhel-8-control-plane.qcow2
export TF_VAR_repo_path="$HOME"/services/p2-files/terra_kvm/meta/repo/repos.iso
export TF_VAR_meta_path="$HOME"/p2-inz-project/Meta/meta.iso
export TF_VAR_ansible_path="$HOME"/p2-inz-project/Meta/ansible.iso
```


# Tworzenie sieci!


```xml
<network>
  <name>mynet</name>
  <bridge name="virbr10" />
  <forward mode="nat"/> <!-- or 'isolated' or 'route' -->
  <ip address="192.168.100.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.100.100" end="192.168.100.200" />
    </dhcp>
  </ip>
</network>
```



<network>
  <name>bridgenet</name>
    <forward mode='bridge'/>
    <bridge name='virbr0'/>
</network>



virsh net-define bridgenet.xml
virsh net-start bridgenet
virsh net-autostart bridgenet








# Virsh destroy
```bash

#!/bin/bash

# Virsh domains
virsh shutdown control-plane
virsh undefine control-plane

virsh shutdown node1
virsh undefine node1

virsh shutdown node2
virsh undefine node2
# Volumes
virsh vol-delete control_plane.iso default
virsh vol-delete node1.iso default
virsh vol-delete node2.iso default
# Network
virsh net-undefine internal
virsh net-destroy internal


```






To add a bridge connection (`nm-bridge2`) on **RHEL** using **`NetworkManager`** while keeping your physical interface (`ens18`) unchanged, here's how you can proceed. We’ll create a bridge device and connect `ens18` as a **port** to the bridge, but ensure that `ens18`’s settings (e.g., IP, etc.) move to the bridge, while the interface itself is not renamed or changed.

---

### 🧱 Step-by-step Instructions

1. **Create the bridge device**:
   ```bash
   nmcli connection add type bridge autoconnect yes con-name nm-bridge2 ifname nm-bridge2
   ```

2. **Create a bridge-slave (port) connection for ens18**:
   This does **not** change `ens18`, it just associates it as a port to the bridge.
   ```bash
   nmcli connection add type ethernet slave-type bridge con-name ens18-slave ifname ens18 master nm-bridge2
   ```

3. **Optionally, move existing IP configuration from `ens18` to `nm-bridge2`**:
   If `ens18` already has an IP (either static or DHCP), delete or modify its connection profile and apply it to `nm-bridge2`.

   Example: Set DHCP on bridge:
   ```bash
   nmcli connection modify nm-bridge2 ipv4.method auto
   nmcli connection modify nm-bridge2 ipv6.method ignore
   ```

4. **Disable and delete any existing standalone connection on `ens18` (if needed)**:
   (Only if `ens18` is already managed by a separate profile and might conflict)
   ```bash
   nmcli connection delete ens18
   ```

5. **Bring up the new connections**:
   ```bash
   nmcli connection up nm-bridge2
   nmcli connection up ens18-slave
   ```

---

### 🔍 To Verify

- Check bridge and slave status:
  ```bash
  nmcli device status
  ```

- Show detailed bridge info:
  ```bash
  nmcli connection show nm-bridge2
  ```

- Inspect bridge interfaces:
  ```bash
  bridge link
  ```

---

Would you like this bridge to have a static IP instead of DHCP? And are you using it for something specific (e.g., KVM, containers, etc.)?





Ah, got it — if the `nm-bridge2` connection no longer exists, no worries — we can recreate it cleanly from scratch. Here’s a safe, clean way to re-establish the Linux bridge with `nmcli` and properly hook up your `ens18`.

---

### 🧱 Step-by-Step: Recreate `nm-bridge2` with `ens18`

#### 1. 🧹 First, delete any leftover config (optional, but avoids conflicts):
```bash
nmcli connection delete ens18
nmcli connection delete ens18-slave
nmcli connection delete nm-bridge2
```

You can skip any of these if they don’t exist.

---

#### 2. ➕ Create the bridge:
```bash
nmcli connection add type bridge autoconnect yes con-name nm-bridge2 ifname nm-bridge2
```

---

#### 3. ➕ Create a slave port for `ens18`:
```bash
nmcli connection add type ethernet slave-type bridge con-name ens18-slave ifname ens18 master nm-bridge2
```

---

#### 4. 🌐 Set IP (pick **either DHCP or static**):

**For DHCP:**
```bash
nmcli connection modify nm-bridge2 ipv4.method auto
nmcli connection modify nm-bridge2 ipv6.method ignore
```

**Or for static:**
```bash
nmcli connection modify nm-bridge2 ipv4.addresses 192.168.1.54/24
nmcli connection modify nm-bridge2 ipv4.gateway 192.168.1.1
nmcli connection modify nm-bridge2 ipv4.dns 192.168.1.1
nmcli connection modify nm-bridge2 ipv4.method manual
nmcli connection modify nm-bridge2 ipv6.method ignore
```

---

#### 5. 🔄 Bring everything up:
```bash
nmcli connection up nm-bridge2
nmcli connection up ens18-slave
```

If you get any "device already managed" error, reboot or manually bring the device down:
```bash
nmcli device disconnect ens18
```

---

### 🔍 Final Checks:

- Confirm bridge is up:
  ```bash
  ip addr show nm-bridge2
  ```

- Confirm `ens18` is now a slave:
  ```bash
  bridge link
  ```

- Confirm connectivity:
  ```bash
  ping -I nm-bridge2 192.168.1.1
  ```

---

Let me know if you want to make this connection persist across reboots (it should already, but we can double-check `autoconnect` settings), or if you're running into `NetworkManager` conflicts or `firewalld` issues.


