kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml -O

sed -i 's/\(cidr:\) .*/\1 10.0.0.0\/16/' custom-resources.yaml
sed -i 's/\(encapsulation:\) .*/\1 VXLAN/' custom-resources.yaml

kubectl apply -f custom-resources.yaml

cd /usr/local/bin/

curl -L https://github.com/projectcalico/calico/releases/download/v3.29.2/calicoctl-linux-amd64 -o calicoctl

chmod +x ./calicoctl

cd ~

watch kubectl get pods -n calico-system
