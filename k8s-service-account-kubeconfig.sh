#!/bin/bash -e

#https://dev.to/danielkun/kubernetes-certificates-tokens-authentication-and-service-accounts-4fj7
#https://dev.to/petermbenjamin/kubernetes-security-best-practices-hlk
#https://gardener.cloud/050-tutorials/content/howto/working-with-kubeconfig/

# Usage ./k8s-service-account-kubeconfig.sh ( namespace ) ( service account name )

TEMPDIR=$( mktemp -d )

trap "{ rm -rf "$TEMPDIR" ; exit 255; }" EXIT

SA_SECRET="$( kubectl get sa -n "$1" "$2" -o jsonpath='{.secrets[0].name}' )"

# Pull the bearer token and cluster CA from the service account secret.
BEARER_TOKEN=$( kubectl get secrets -n "$1" "$SA_SECRET" -o jsonpath='{.data.token}' | base64 -d )
kubectl get secrets -n "$1" "$SA_SECRET" -o jsonpath='{.data.ca\.crt}' | base64 -d > "$TEMPDIR/ca.crt"
CA_DATA=$(kubectl config view --flatten --minify -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')
CLUSTER_URL=$( kubectl config view -o jsonpath='{.clusters[0].cluster.server}' )
CLUSTER_NAME=$( kubectl config view -o jsonpath='{.clusters[0].name}' )

#KUBECONFIG=kubeconfig

#kubectl config --kubeconfig="$KUBECONFIG" \
#    set-cluster \
#    "$CLUSTER_URL" \
#    --server="$CLUSTER_URL" \
#    --certificate-authority="$TEMPDIR/ca.crt" \
#    --embed-certs=true

#kubectl config --kubeconfig="$KUBECONFIG" \
#    set-credentials "$2" --token="$BEARER_TOKEN"

#kubectl config --kubeconfig="$KUBECONFIG" \
#    set-context registry \
#    --cluster="$CLUSTER_URL" \
#    --user="$2"

#kubectl config --kubeconfig="$KUBECONFIG" \
#    use-context registry

#echo "kubeconfig written to file \"$KUBECONFIG\""

cat <<EOF > "$HOME"/.kube/"$2"-config
apiVersion: v1
kind: Config
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CA_DATA}
    server: ${CLUSTER_URL}
contexts:
- name: ${2}
  context:
    cluster: ${CLUSTER_NAME}
    user: ${2}
current-context: ${CLUSTER_NAME}
users:
- name: ${2}
  user:
    token: ${BEARER_TOKEN}
EOF

echo "kubeconfig written to file $HOME/.kube/$2-config"
