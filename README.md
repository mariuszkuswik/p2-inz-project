# Instalacja 
## WAŻNE 
Przed zainstaowaniem należy pobrać obraz rhel8 w formacie qcow2

ls p2-files/rhel-8.10-x86_64-kvm.qcow2


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
dnf install qemu-kvm  libvirt virt-install terraform ansible mongocli.x86_64 genisoimage -y 
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
mkdir "$HOME"/virsh-pool-default
# Terraform ma podaną sesję system, więc w przypadku virsh poole również tworzymy przez system
virsh --connect qemu:///system pool-define-as --name default --type dir --target "$HOME"/virsh-pool-default
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



## Zainicjowanie zmiennych
