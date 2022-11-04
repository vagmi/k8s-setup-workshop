# Kuberenetes workshop setup

This example sets up a 3 node kubernetes cluster. It uses docker and kubeadm
on digital ocean. It is meant for teaching k8s concepts and is not meant for 
for production.

You can setup the cluster with the following commands. This creates the keypair
and the inventory file.

```
export DO_TOKEN=do-xxxxx
export PREFIX=vagmi-cluster
terraform apply -var "do_token=$DO_TOKEN" -var "prefix=$PREFIX" 
```

You can run the playbook there.

```
ssh-add ./id_rsa
cd ansible
ansible-playbook -i inventory setup.yml
```

You can then ssh into the machine to check if everything works. 

```
ssh deploy@`tf output --raw control_ip` kubectl get nodes
```


