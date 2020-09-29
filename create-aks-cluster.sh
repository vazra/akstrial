# set the default subscription
SUBSCRIPTION=xxx-xxx-xxx # TODO: add your subscription id here
az account set --subscription $SUBSCRIPTION
az account list -o table

# get locations available
# az account list-locations

# create resource group 
RG='hatchpod-dev3-rg'
az group create -n $RG -l eastus

# Create Service Principal
SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name hatchpod-dev3-sp -o json)
SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$RG" \
--role Contributor

#if acr dont exist - create it
# az acr create -n vazradev -g $RG --sku Basic -l eastus

# create cluster
az aks create -n hatchpod-dev3-aks \
--resource-group $RG \
--location eastus \
--kubernetes-version 1.18.8 \
--load-balancer-sku standard \
--nodepool-name default \
--node-count 1 \
--node-vm-size Standard_B2s  \
--node-osdisk-size 50 \
--ssh-key-value ~/.ssh/id_rsa.pub \
--network-plugin kubenet \
--service-principal $SERVICE_PRINCIPAL \
--client-secret $SERVICE_PRINCIPAL_SECRET \
--output none \
--attach-acr vazradev

# Setup Kubectl
az aks get-credentials -n hatchpod-dev3-aks --resource-group $RG --admin

#grab the config if you want it
# cp ~/.kube/config ~/.kube/config_hatchpod_dev


# add traefik
kubectl create ns traefik
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm repo update
helm install traefik traefik/traefik -n traefik
kubectl apply -f ./ingress/traefik-ingress.yml -n traefik

# add talehunt (TODO: instead of talehunt add your services here)
kubectl create ns talehunt
kubectl apply -n talehunt -f ../deploys/talehunt/dev.yml

# List all deployments in all namespaces
kubectl get deployments --all-namespaces
kubectl get svc --all-namespaces

# kubectl create secret generic cloudflare --from-literal=dns-token=xxxxxx

# kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000
# az aks update -n myAKSCluster -g $RG --attach-acr vazra

#after creating add resource group and service-pricipal-id tot he delete-aks-cluster script so that it can be deleted with the script!
echo "RG - $RG"
echo "SERVICE_PRINCIPAL - $SERVICE_PRINCIPAL"

