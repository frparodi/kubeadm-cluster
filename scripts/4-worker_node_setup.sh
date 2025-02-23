{

# Run the following if token was missed
# kubeadm token create --print-join-command

kubeadm join 10.0.0.189:6443 --token lu121h.8ymsh85byoxp5l3q \
        --discovery-token-ca-cert-hash sha256:b6d5769973def53c54d558187db62873ba70c522e59d38259d0adbccaa18203f 

}