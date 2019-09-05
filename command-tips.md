# Docker dicas

## Containers

  ### Visualizar todos os containers em execução
    TODO
  
  ### Rodar um container

   TODO
  ### Parar um container
   TODO

  ### Reinicar um container parado 
  TODO

  ### Remover todos os containers parados 
   
   ```sh
    $ docker container prune
   ```
---

## Volumes:

   ### volume do tipo bind:
   
   ```sh
   $ docker container run -ti --mount type=bind,src=/home/renato/workspace/giropops,dst=/giropos debian
   ```
   > nota: O volume do tipo bind nada mais é que uma pasta montada dentro do container
   
   ### volume do tipo volume:
 
   ```sh 
    $ docker volume create giropops2
    $ docker container run -ti --mount type=volume,src=giropops2,dst=/giropos debian
   ```
   > nota: o volume do tipo volume é gerenciado pelo docker e ficam localizados em  `/var/lib/docker/volumes/<nome_volume>/_data/`
   
   ### volume somente leitura:

   ```sh
    $ docker container run -ti --mount type=bind,src=/root/primeiro_container,dst=/volume,ro ubuntu
   ```
   
   ### volume data only:
 
   ```sh 
    $ docker container create -v /data --name dbdados centos
    $ docker container run -d --from-volume dbdados  -p 5432:5432 -e POSTGRES_USER=fulano -e POSTGRES_PASSWORD=s3cret POSTGRES_DB=foo postgres:10 
   ```

   > nota: Opção obsoleta, porém é pedida no exame de certificação

   ## limpar todos os volumes

   ```sh 
    $ docker volume prune
   ```
   > nota: remove dos os volumes **não** usados por containeres. Avalie se pode remover todos os comandos   





Para verificar se ele foi instalado e qual a sua versão, faça:

# docker-machine version

# docker-machine create --driver virtualbox linuxtips

# docker-machine ls

# docker-machine env linuxtips

# eval "$(docker-machine env linuxtips)"

# docker container ls

# docker container run busybox echo "LINUXTIPS, VAIIII"

# docker-machine ip linuxtips

# docker-machine ssh linuxtips

# docker-machine inspect linuxtips

# docker-machine stop linuxtips

# docker-machine ls 

# docker-machine start linuxtips

# docker-machine rm linuxtips

# eval $(docker-machine env -u)

==============================================================================================================

# docker swarm init

# docker swarm join --token \ SWMTKN-1-100_SEU_TOKEN SEU_IP_MASTER:2377

# docker node ls

# docker swarm join-token manager

# docker swarm join-token worker

# docker node inspect LINUXtips-02

# docker node promote LINUXtips-03

# docker node ls

# docker node demote LINUXtips-03

# docker swarm leave

# docker swarm leave --force

# docker node rm LINUXtips-03

# docker service create --name webserver --replicas 5 -p 8080:80  nginx

# curl QUALQUER_IP_NODES_CLUSTER:8080

# docker service ls

# docker service ps webserver

# docker service inspect webserver

# docker service logs -f webserver

# docker service rm webserver

# docker service create --name webserver --replicas 5 -p 8080:80 --mount type=volume,src=teste,dst=/app  nginx

# docker network create -d overlay giropops

# docker network ls

# docker network inspect giropops

# docker service scale giropops=5

# docker network rm giropops

# docker service create --name webserver --network giropops --replicas 5 -p 8080:80 --mount type=volume,src=teste,dst=/app  nginx

# docker service update <OPCOES> <Nome_Service> 

======================================================
echo 'minha secret' | docker secret create 
docker secret create minha_secret minha_secret.txt
docker secret inspect minha_secret
docker secret ls
docker secret rm minha_secret
docker service create --name app --detach=false --secret db_pass  minha_app:1.0
docker service create --detach=false --name app --secret source=db_pass,target=password,uid=2000,gid=3000,mode=0400 minha_app:1.0
ls -lhart /run/secrets/
docker service update --secret-rm db_pass --detach=false --secret-add source=db_pass_1,target=password app
======================================================================================



## criando limits range para um namespace
kubectl create -f limits_ranger.yaml -n giropops (namespace)


kubectl describe limitrange

kubectl describe limitranges -n giropops limitando-recursos


## traints

# kubectl describe nodes elliot-01 | grep -i taint
Taints:             node-role.kubernetes.io/master:NoSchedule

# kubectl describe nodes  | grep -i taints

# kubectl taint node elliot-01 node-role.kubernetes.io/master:NoSchedule-

# kubectl taint node elliot-01 node-role.kubernetes.io/master:NoSchedule

# kubectl taint node elliot-02 key1=value1:NoSchedule

# kubectl taint node elliot-02 key1=value1:NoSchedule-

# kubectl get pods -o wide

# kubectl taint node elliot-02 key1=value1:NoExecute-

# kubectl taint node elliot-02 key1=value1:NoExecute

# kubectl get pods -o wide

# kubectl taint node all key1=value1:NoExecute

kubectl taint node linuxtips-ohee key1:NoSchedule-


## labels

# kubectl get pods -l dc=UK

# kubectl get pods -l dc=Netherlands

# kubectl get pod -L dc

# kubectl label nodes elliot-02 dc-

# kubectl label nodes --all dc-

# kubectl label node elliot-02 disk=SSD

# kubectl label node elliot-02 dc=UK

# kubectl label node elliot-03 dc=Netherlands

# kubectl label nodes elliot-03 disk=hdd

# kubectl label nodes elliot-03 disk=HDD --overwrite

# kubectl label nodes elliot-02 --list

# kubectl label nodes elliot-03 --list

===================================================
rollout 

# kubectl rollout history ds daemon-set-primeiro

# kubectl rollout history ds daemon-set-primeiro --revision=1

# kubectl rollout history ds daemon-set-primeiro --revision=2

# kubectl rollout undo ds daemon-set-primeiro --to-revision=1

# kubectl rollout status ds daemon-set-primeiro 

# kubectl describe daemon-set-primeiro-hp4qc | grep -i image:

# kubectl delete -f primeiro-daemonset.yaml

html
# vim primeiro-daemonset.yaml

apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: daemon-set-primeiro
spec:
  template:
    metadata:
      labels:
        system: DaemonOne
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
  updateStrategy:
    type: RollingUpdate
    
    
# kubectl create -f primeiro-daemonset.yaml

# kubectl get daemonset

# kubectl describe ds daemon-set-primeiro

# kubectl get ds daemon-set-primeiro -o yaml | grep -A 2 Strategy

# kubectl set image ds daemon-set-primeiro nginx=nginx:1.15.0

# kubectl get daemonset

# kubectl get pods -o wide

# kubectl describe ds daemon-set-primeiro

# kubectl rollout history ds daemon-set-primeiro

# kubectl rollout history ds daemon-set-primeiro --revision=1

# kubectl rollout history ds daemon-set-primeiro --revision=2

# kubectl rollout undo ds daemon-set-primeiro --to-revision=1

# kubectl rollout status ds daemon-set-primeiro

# kubectl delete ds daemon-set-primeiro

# kubectl --record deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1

# kubectl annotate deployment.apps/giropops-v2 kubernetes.io/change-cause="image updated to 1.9.1"


kubectl --record deployment.apps/giropops-v2 set image deployment.v1.apps/giropops-v2 giropops=nginx:1.9.1

====================================================

   Secrets - Comandos
html
# echo -n "descomplicando-k8s" > secret.txt

# kubectl create secret generic my-secret --from-file=secret.txt

# kubectl describe secret my-secret

# kubectl get secret

# kubectl get secret my-secret -o yaml

# echo 'ZGVzY29tcGxpY2FuZG8tazhz' | base64 --decode

html
# vim pod-secret.yaml
apiVersion: v1
kind: Pod
metadata:
  name: teste-secret
  namespace: default
spec:
  containers:
  - image: busybox
    name: busy
    command:
      - sleep
      - "3600"
    volumeMounts:
    - mountPath: /tmp/giropops
      name: my-volume-secret
  volumes:
  - name: my-volume-secret
    secret:
      secretName: my-secret
html
# kubectl create -f pod-secret.yaml

# kubectl exec -ti teste-secret -- ls /tmp/giropops

# kubectl exec -ti teste-secret -- cat /tmp/giropops/secret.txt

# kubectl create secret generic my-literal-secret --from-literal user=linuxtips --from-literal password=catota

# kubectl describe secret my-literal-secret

html
# vim pod-secret-env.yaml
apiVersion: v1
kind: Pod
metadata:
  name: teste-secret-env
  namespace: default
spec:
  containers:
  - image: busybox
    name: busy-secret-env
    command:
      - sleep
      - "3600"
    env:
    - name: MEU_USERNAME
      valueFrom:
        secretKeyRef:
          name: my-literal-secret
          key: user
    - name: MEU_PASSWORD
      valueFrom:
        secretKeyRef:
          name: my-literal-secret
          key: password
html
# kubectl create -f pod-secret-env.yaml

# kubectl exec teste-secret-env -c busy-secret-env -it -- printenv

================================================

   ConfigMaps - Comandos
html
# mkdir frutas

# echo amarela > frutas/banana

# echo vermelho > frutas/morango

# echo verde > frutas/limao

# echo "verde e vermelha" > frutas/melancia

# echo kiwi > predileta

# git clone https://bitbucket.org/gcalcette/book-descomplicando-k8s.git

# kubectl create configmap cores-frutas --from-literal=uva=roxa --from-file=predileta --from-file=frutas/

# kubectl get configmap

html
# vim pod-configmap.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-configmap
  namespace: default
spec:
  containers:
  - image: busybox
    name: busy-configmap
    command:
      - sleep
      - "3600"
    env:
    - name: frutas
      valueFrom:
        configMapKeyRef:
          name: cores-frutas
          key: predileta
#    envFrom:
#    - configMapRef:
#        name: cores-frutas
html
# kubectl create -f pod-configmap.yaml
html
# cat pod-configmap-file.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-configmap-file
  namespace: default
spec:
  containers:
  - image: busybox
    name: busy-configmap
    command:
      - sleep
      - "3600"
    volumeMounts:
    - name: meu-configmap-vol
      mountPath: /etc/frutas
  volumes:
  - name: meu-configmap-vol
    configMap:
      name: cores-frutas
html
# kubectl create -f pod-configmap-file.yaml
html

==================================================


   RBAC - Comandos
html
# kubectl create serviceaccount jeferson

# kubectl create clusterrolebinding toskeria --serviceaccount=default:jeferson --clusterrole=cluster-admin
html
# vim admin-user.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system

html
# vim admin-cluster-role-binding.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
html
# kubectl create -f admin-user.yaml

# kubectl create -f admin-cluster-role-binding.yaml
















