# TODO 
- Dodać wszystkie repozytoria do porjektu, w katalogu Meta/repo_files można je wrzucić
- Utworzyć nową sieć bridgenet!
- Upewnić się czy wirtualizacja na danym hoście jest włączona, koniecne dla działania Terraform, sprawdzić to możemy przez:
```bash
egrep -wo 'vmx|svm' /proc/cpuinfo
lsmod | grep kvm
```

export LIBVIRT_DEFAULT_URI=qemu:///system


# Utworzenie interfejsu sieciowego bridge?
sudo nmcli connection add type bridge con-name nm-bridge2 ifname nm-bridge2
sudo nmcli connection up nm-bridge2



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
dnf install qemu-kvm  libvirt virt-install terraform ansible mongocli.x86_64 genisoimage virt-manager -y 
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







│ Error: error creating libvirt domain: Requested operation is not valid: network 'bridgenet' is not active                                                                                                                            
│                                                                                                                                                                                                                                      
│   with module.node.libvirt_domain.node[1],                                                                                                                                                                                           
│   on modules/node/main.tf line 32, in resource "libvirt_domain" "node":                                                                                                                                                              
│   32: resource "libvirt_domain" "node" {                                                                                                                                                                                             
│                                                                                                                                                                                                                                      
╵                                                                                                                                                                                                                                      
╷                                                                                                                                                                                                                                      
│ Error: error creating libvirt domain: Requested operation is not valid: network 'bridgenet' is not active                                                                                                                            
│                                                                                                                                                                                                                                      
│   with module.node.libvirt_domain.node[0],                                                                                                                                                                                           
│   on modules/node/main.tf line 32, in resource "libvirt_domain" "node":
│   32: resource "libvirt_domain" "node" {
