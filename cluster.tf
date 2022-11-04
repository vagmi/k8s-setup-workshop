resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "private_key" {
  filename        = "${path.module}/id_rsa"
  content         = tls_private_key.ssh_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "public_key" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.ssh_key.public_key_openssh
}


resource "digitalocean_ssh_key" "k8skey" {
  name       = "${var.prefix}-droplet-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}


resource "digitalocean_droplet" "control" {
  name     = "${var.prefix}-control"
  image    = "ubuntu-20-04-x64"
  region   = var.do_region
  size     = var.droplet_size
  ssh_keys = [digitalocean_ssh_key.k8skey.fingerprint]

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = "root"
      private_key = tls_private_key.ssh_key.private_key_pem
    }
  }
}

resource "digitalocean_droplet" "worker" {
  count    = var.worker_count
  name     = "${var.prefix}-worker-${count.index}"
  image    = "ubuntu-20-04-x64"
  region   = var.do_region
  size     = var.droplet_size
  ssh_keys = [digitalocean_ssh_key.k8skey.fingerprint]

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = "root"
      private_key = tls_private_key.ssh_key.private_key_pem
    }
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl", {
    number_of_workers = range(var.worker_count)
    control_ip = digitalocean_droplet.control.ipv4_address
    worker_ips = digitalocean_droplet.worker.*.ipv4_address
  })
  filename = "ansible/inventory"
}
