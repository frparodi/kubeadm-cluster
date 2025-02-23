kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-
# kubectl taint nodes --all node-role.kubernetes.io/control-plane-

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml -O

vim custom-resources.yaml

kubectl create -f custom-resources.yaml

watch kubectl get pods -n calico-system

cd /usr/local/bin/

curl -L https://github.com/projectcalico/calico/releases/download/v3.29.2/calicoctl-linux-amd64 -o calicoctl

chmod +x ./calicoctl

