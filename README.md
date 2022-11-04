# Kuberenetes workshop setup

This example sets up a 3 node kubernetes cluster. It uses docker and kubeadm
on digital ocean. It is meant for teaching k8s concepts and is not meant for 
for production.

To run this setup the `do_token` variable in the tfvars file and run
`terraform apply`. Once that succeeds, it will create an inventory file
in the ansible folder.

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


