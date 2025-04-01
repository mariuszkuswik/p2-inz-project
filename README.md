# Instalacja 
# Utworzenie repozytoriów
*Wszystkie kroki przedstawione są dla RH9/Rocky9*

## Instalacja repozytorium epel
```bash
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
```

## Podpięcie repozytorium mongo
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

## Podpięcie repozytorium terraform
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

# Instalacja paczek
```bash
dnf install qemu-kvm  libvirt virt-install terraform ansible mongocli.x86_64 genisoimage -y 
```