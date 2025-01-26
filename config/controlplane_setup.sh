{
sudo kubeadm init --apiserver-advertise-address=10.0.0.245 --apiserver-cert-extra-sans=controlplane --pod-network-cidr=10.0.0.0/16

mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
}
