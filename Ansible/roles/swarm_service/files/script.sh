docker service create  --name traefik  --publish 8080:80 --publish 8081:8080 --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock --mount type=bind,source=/home/ans_mariusz/p2-inz-project/Ansible/roles/swarm_service/files/traefik.yml,target=/traefik.yml --constraint=node.role==manager  traefik:v2.5 --configfile=/traefik.yml

